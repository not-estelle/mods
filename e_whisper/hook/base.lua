if E.whisper then return end

E.whisper = {
  last_peer_id = nil,
}

function E.whisper:send(peer_ids, message)
  if string.len(message) == 0 then return end

  E.whisper.last_peer_ids = peer_ids

  if not managers.network:session() then return end
  local me = managers.network:session():local_peer()
  local peers = managers.network:session():all_peers()
  if not peers then return end

  recipients = {}
  for _, id in ipairs(peer_ids) do
    local peer = peers[id]
    if peer then
      table.insert(recipients, peer)
      if me ~= peer then
        peer:send("send_chat_message", ChatManager.GAME, message)
      end
    end
  end
  E.whisper:print(recipients, message)
end
function E.whisper:print(recipients, message)
  if #recipients == 0 then return end
  local me = managers.network:session() and managers.network:session():local_peer()
  -- local icon = tweak_data.infamy.infamy_icons[#tweak_data.infamy.infamy_icons].hud_icon
  -- managers.chat:_receive_message(ChatManager.GAME, "to " .. name, message, color, icon)

  local rich_string = {
    E.rich_string:peer_name(me),
  }
  if #recipients > 1 or me ~= recipients[1] then
    table.insert(rich_string, {" to "})
    local first = true
    for _, peer in ipairs(recipients) do
      if me ~= peer then
        if first then
          first = false
        else
          table.insert(rich_string, {", "})
        end
        table.insert(rich_string, E.rich_string:peer_name(peer))
      end
    end
  end
  table.insert(rich_string, {": " .. message})
  E.commands:print(rich_string, "pd2_talk")
end

function E.whisper:send_last(message)
  local peer_ids = E.whisper.last_peer_ids
  if not peer_ids then
    E.commands:print_error("w", "must whisper to someone first")
    return
  end
  E.whisper:send(peer_ids, message)
end

E.commands:register({
  name = "wg",
  usage = "$0 <message>",
  summary = "whisper to green",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", {1})
})
E.commands:register({
  name = "wng",
  usage = "$0 <message>",
  summary = "whisper except to green",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", {2, 3, 4})
})
E.commands:register({
  name = "wb",
  usage = "$0 <message>",
  summary = "whisper to blue",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", {2})
})
E.commands:register({
  name = "wnb",
  usage = "$0 <message>",
  summary = "whisper except to blue",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", {1, 3, 4})
})
E.commands:register({
  name = "wr",
  usage = "$0 <message>",
  summary = "whisper to red",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", {3})
})
E.commands:register({
  name = "wnr",
  usage = "$0 <message>",
  summary = "whisper except to red",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", {1, 2, 4})
})
E.commands:register({
  name = "wy",
  usage = "$0 <message>",
  summary = "whisper to yellow",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", {4})
})
E.commands:register({
  name = "wny",
  usage = "$0 <message>",
  summary = "whisper except to yellow",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", {1, 2, 3})
})
E.commands:register({
  name = "w",
  usage = "$0 <message>",
  summary = "whisper to last recipient",
  description = {
    {{"after /"}, E.rich_string:command("wg"), {", /"}, E.rich_string:command("wb"), {", /"}, E.rich_string:command("wr"), {", or /"}, E.rich_string:command("wy"), {", use /"}, E.rich_string:command("w"), {" to message the same person again"}}
  },
  raw = true,
  callback = callback(E.whisper, E.whisper, "send_last")
})
