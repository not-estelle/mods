E:mod("ping")

function E.ping:show_ping(peer_id)
  peer_id = E.commands:parse_peer(peer_id)

  local peers = managers.network:session():peers()
  if not peers then return end

  local peer = peers[peer_id]
  if not peer then return end

  local qos = Network:qos(peer:rpc())
  if not qos then return end

  local ping = math.floor(qos.ping + 0.5)
  E.commands:print({
    {"ping to "},
    E.rich_string:peer_name(peer),
    {": "},
    {tostring(ping) .. " ms", tweak_data.screen_colors.resource},
  })
end

E.commands:register({
  name = "ping",
  usage = "$0 <peer>",
  summary = "ping a peer",
  callback = callback(E.ping, E.ping, "show_ping"),
})

E.commands:register({
  name = "pingg",
  usage = "$0",
  summary = "ping green",
  callback = callback(E.ping, E.ping, "show_ping", 1),
})
E.commands:register({
  name = "pingb",
  usage = "$0",
  summary = "ping blue",
  callback = callback(E.ping, E.ping, "show_ping", 2),
})
E.commands:register({
  name = "pingr",
  usage = "$0",
  summary = "ping red",
  callback = callback(E.ping, E.ping, "show_ping", 3),
})
E.commands:register({
  name = "pingy",
  usage = "$0",
  summary = "ping yellow",
  callback = callback(E.ping, E.ping, "show_ping", 4),
})
