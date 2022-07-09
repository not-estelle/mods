E:mod("ping")

E.ping._update_t = 0
-- E.ping._pings = {}

function E.ping:update_pings(t, dt)
  self._update_t = self._update_t - dt
  if self._update_t > 0 then return end
  self._update_t = math.max(self._update_t, -0.5) + 1

  E.ping._pings = {}
  local session = managers.network:session()
  if not session then return end

  for i, panel in ipairs(managers.hud._teammate_panels) do
    local peer_id = panel:peer_id()
    local peer = peer_id and session:peer(peer_id)
    if peer then
      local qos = Network:qos(peer:rpc())
      if qos then
        E.ping:set_teammate_ping(i, qos.ping)
      end
    end
  end
  -- local local_peer = session:local_peer()
  -- for id, peer in pairs(session:peers()) do
  --   if peer ~= local_peer then
  --     local qos = Network:qos(peer:rpc())
  --     if qos then
  --       E.ping._pings[id] = math.floor(qos.ping + 0.5)
  --     end
  --   end
  -- end
end
function E.ping:set_teammate_ping(i, ping)
  local panel = managers.hud._teammate_panels[i]
  if not panel then return end
  local text = panel._player_panel:child("E_ping_text")
  if not text then return end
  -- E:log("set ping", i, ping)
  text:set_text(E.ping:format_ping(ping))
  text:set_color(E.ping:ping_color(ping))
end

function E.ping:show_ping_command(peer_id)
  peer_id = E.commands:parse_peer(peer_id)

  local peers = managers.network:session():peers()
  if not peers then return end

  local peer = peers[peer_id]
  if not peer then return end

  local qos = Network:qos(peer:rpc())
  if not qos then return end

  E.commands:print({
    {"ping to "},
    E.rich_string:peer_name(peer),
    {": "},
    {E.ping:format_ping_long(qos.ping), E.ping:ping_color(qos.ping)},
  })
end

function E.ping:format_ping(ping)
  if ping < 1000 then
    return tostring(math.floor(ping + 0.5))
  else
    return ">" .. tostring(math.floor(ping / 1000)) .. "s"
  end
end
function E.ping:format_ping_long(ping)
  return tostring(math.floor(ping + 0.5)) .. " ms"
end
function E.ping:ping_color(ping)
  if ping <= 20 then
    return tweak_data.screen_colors.friend_color
  elseif ping <= 50 then
    return Color.white -- tweak_data.screen_colors.stats_positive
  elseif ping <= 100 then
    return tweak_data.screen_colors.crime_spree_risk
  elseif ping <= 150 then
    return tweak_data.screen_colors.heat_warm_color
  elseif ping <= 200 then
    return tweak_data.screen_colors.skirmish_color
  else
    return tweak_data.screen_colors.one_down
  end
end

E.commands:register({
  name = "ping",
  usage = "$0 <peer>",
  summary = "ping a peer",
  callback = callback(E.ping, E.ping, "show_ping_command"),
})

E.commands:register({
  name = "pingg",
  usage = "$0",
  summary = "ping green",
  callback = callback(E.ping, E.ping, "show_ping_command", 1),
})
E.commands:register({
  name = "pingb",
  usage = "$0",
  summary = "ping blue",
  callback = callback(E.ping, E.ping, "show_ping_command", 2),
})
E.commands:register({
  name = "pingr",
  usage = "$0",
  summary = "ping red",
  callback = callback(E.ping, E.ping, "show_ping_command", 3),
})
E.commands:register({
  name = "pingy",
  usage = "$0",
  summary = "ping yellow",
  callback = callback(E.ping, E.ping, "show_ping_command", 4),
})
