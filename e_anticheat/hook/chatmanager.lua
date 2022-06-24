Hooks:PreHook(ChatManager, "receive_message_by_peer", "E.anticheat ChatManager.receive_message_by_peer", function(self, channel_id, peer, message)
  if channel_id == LuaNetworking.HiddenChannel then
    if string.match(message, '/BCO/') ~= nil then
      E:log("anticheat:", peer:id(), "has beardlib")
      peer.E_anticheat_has_beardlib = true
      E.anticheat:peer_updated(peer)
    end
  end
end)
