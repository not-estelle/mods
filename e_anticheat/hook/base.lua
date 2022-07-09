E:mod("anticheat", {})

E.anticheat.good_mods = {
  "cheater kicker",
  "cheater kicker plus",
  "hacker cancer",
  "hacker pecm fix",
}
E.anticheat.bad_mods = {
  "pirate perfection",
  "rngmodifier",
  "p3dhack",
  "p3dhack free",
  "dlc unlocker",
  "skin unlocker",
  "p3dunlocker",
  "arsium's weapons rebalance recoil",
  "overkill mod",
  "selective dlc unlocker",
  "the great skin unlock",
  "beyond cheats",
  "fuck the flashbangs",
  "unhittable armour",
  "nokick4u",
  "instant overdrill",
  -- "texturei",
  "ultimate trainer 4",
}
E.anticheat.bad_mod_pats = {
  "pirate",
  "p3d",
  "hack",
  "cheat",
  "unlock",
  "dlc",
  "trainer",
  "silent ?assassin",
  "carry stacker",
  "god",
  "x%-?ray",
  "mvp",
  "rebalance",
  "cook faster",
  "no pager on domination"
}
E.anticheat.bad_exact_color = E.commands.error_color
E.anticheat.bad_pattern_color = tweak_data.screen_colors.heat_warm_color

function E.anticheat:peer_updated(peer)
  if peer.E_anticheat_synced then
    self:check_peer(peer)
  else
    DelayedCalls:Add("E.anticheat synced " .. tostring(peer), 3, function()
      local session = managers.network:session()
      if not session then return end
      local local_peer = session:local_peer()
      if not local_peer or (not local_peer:synched() or not peer:synched()) and not local_peer:in_lobby() then
        E.anticheat:peer_updated(peer)
        return
      end
      E:log("anticheat:", peer:id(), "synced")
      peer.E_anticheat_synced = true
      E.anticheat:check_peer(peer)
    end)
  end
end

function E.anticheat:check_peer(peer)
  -- local local_peer = managers.network:session():local_peer()
  -- E:log("anticheat:", peer:id(), "check",
  --   "E_anticheat_synced", peer.E_anticheat_synced,
  --   "synched", peer:synched(),
  --   "loaded", peer:loaded(),
  --   "local_peer synched", local_peer:synched(),
  --   "local_peer loaded", local_peer:loaded()
  -- )
  -- if not peer:synched() or not peer.E_anticheat_synced then return end
  -- if not local_peer or not local_peer:synched() or peer == local_peer then return end
  if not peer then return end
  E.anticheat:check_skills(peer)
  if not peer.E_anticheat_synced then return end
  E:log("anticheat:", peer:id(), "check")
  E.anticheat:check_mods(peer)
  E.anticheat:check_beardlib(peer)
end
function E.anticheat:check_mods(peer)
  local mods = peer:synced_mods()
  if not mods then return end

  local reason = {}
  for _,mod in ipairs(mods) do
    local name = string.lower(mod.name)
    local id = string.lower(mod.id)
    local bad = false

    for _, exact in ipairs(E.anticheat.bad_mods) do
      if exact == name or exact == id then
        bad = "exact"
        break
      end
    end
    if not bad then
      for _, pat in ipairs(E.anticheat.bad_mod_pats) do
        if string.match(name, pat) or string.match(id, pat) then
          bad = "pattern"
          break
        end
      end
    end
    if bad then
      for _, exact in ipairs(E.anticheat.good_mods) do
        if exact == name or exact == id then
          bad = false
          break
        end
      end
    end
    if bad then
      if #reason > 0 then
        table.insert(reason, {", "})
      end
      table.insert(reason, {mod.id, bad == "exact" and E.anticheat.bad_exact_color or E.anticheat.bad_pattern_color})
    end
  end
  if #reason == 0 then return end
  table.insert(reason, 1, {"using bad mods: "})
  self:notify_cheater(peer, reason)
end
function E.anticheat:check_beardlib(peer)
  if not peer.E_anticheat_has_beardlib or peer:is_modded() then return end
  -- local user = Steam:user(peer:ip())
  -- local modded = user and user:rich_presence("is_modded") == "1"
  self:notify_cheater(peer, {{"hiding their mods"}})
end
function E.anticheat:check_skills(peer)
  local skills_str = peer:skills()
  local level = tonumber(peer:level())

  if not level or not skills_str then return end
  -- E:log("check peer", peer:id())

  local skills_perks = string.split(skills_str or "", "-")
  local skills = string.split(skills_perks[1] or "", "_")
  for i,n in ipairs(skills) do
    skills[i] = tonumber(n)
  end
  local perks = string.split(skills_perks[2] or "", "_")
  for i,n in ipairs(perks) do
    perks[i] = tonumber(n)
  end

  if #skills ~= #tweak_data.skilltree.trees or #perks ~= 2 then
    self:notify_cheater(peer, {{"ill-formed skills"}})
    return
  end

  local total_pts = 0
  for _,n in ipairs(skills) do
    total_pts = total_pts + n
  end

  local max_pts = self:pts_for_level(level)
  -- E:log("skills:", skills_str, "level:", level, "points:", total_pts, "/", max_pts)
  if total_pts > max_pts then
    self:notify_cheater(peer, {{"too many skill points ("}, {tostring(total_pts), E.commands.error_color}, {"/"}, {tostring(max_pts), tweak_data.screen_colors.resource}, {")"}})
  end

  local perk_id = tonumber(perks[1])
  -- local perk_rank = tonumber(perks[2])
  if not perk_id or perk_id > #tweak_data.skilltree.specializations then
    self:notify_cheater(peer, {{"invalid perk deck"}})
  end
end

function E.anticheat:pts_for_level(level)
  return level + 2 * math.floor(level / 10)
end

function E.anticheat:notify_cheater(peer, reason)
  if not peer.E_cheat_messages then
    peer.E_cheat_messages = {}
  end
  if #peer.E_cheat_messages > 10 then return end
  local reason_str = E.rich_string:concatenate(reason)
  if table.index_of(peer.E_cheat_messages, reason_str) ~= -1 then return end

  table.insert(peer.E_cheat_messages, reason_str)
  local message = {
    E.rich_string:peer_name(peer),
    {" is cheating: ", E.commands.error_color},
    unpack(reason),
  }
  E.commands:print(message, {"pd2_generic_look", tweak_data.system_chat_color})
end
