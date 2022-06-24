if E.whisper then return end

E.whisper = {
  last_peer_id = nil,
}

function E.whisper:send(peer_id, message)
  if string.len(message) == 0 then return end

  E.whisper.last_peer_id = peer_id

  if not managers.network:session() then return end

  local me = managers.network:session():local_peer()
  if me:id() == peer_id then
    E.whisper:print(me, message)
    return
  end

  local peers = managers.network:session():peers()
  if not peers then return end
  local peer = peers[peer_id]
  if not peer then return end

  peer:send("send_chat_message", ChatManager.GAME, message)
  E.whisper:print(peer, message)
end
function E.whisper:print(peer, message)
  local me = managers.network:session() and managers.network:session():local_peer()
  -- local icon = tweak_data.infamy.infamy_icons[#tweak_data.infamy.infamy_icons].hud_icon
  -- managers.chat:_receive_message(ChatManager.GAME, "to " .. name, message, color, icon)

  local rich_string = {
    E.rich_string:peer_name(me),
  }
  if me ~= peer then
    table.insert(rich_string, {" to "})
    table.insert(rich_string, E.rich_string:peer_name(peer))
  end
  table.insert(rich_string, {": " .. message})
  E.commands:print(rich_string, "pd2_talk")
end

function E.whisper:send_last(message)
  local peer_id = E.whisper.last_peer_id
  if not peer_id then
    E.commands:print_error("w", "must whisper to someone first")
    return
  end
  E.whisper:send(peer_id, message)
end

E.commands:register({
  name = "wg",
  usage = "$0 <message>",
  summary = "whisper to green",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", 1)
})
E.commands:register({
  name = "wb",
  usage = "$0 <message>",
  summary = "whisper to blue",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", 2)
})
E.commands:register({
  name = "wr",
  usage = "$0 <message>",
  summary = "whisper to red",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", 3)
})
E.commands:register({
  name = "wy",
  usage = "$0 <message>",
  summary = "whisper to yellow",
  raw = true,
  callback = callback(E.whisper, E.whisper, "send", 4)
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
