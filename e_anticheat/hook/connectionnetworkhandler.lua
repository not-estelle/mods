Hooks:PostHook(ConnectionNetworkHandler, "sync_outfit", "E.anticheat ConnectionNetworkHandler.sync_outfit", function(self, outfit_string, outfit_version, outfit_signature, sender)
  local peer = self._verify_sender(sender)
  if not peer then return end
  -- E:log("anticheat:", peer:id(), "sync_outfit")
  -- E.anticheat:check_peer(peer)
  -- TODO this is sketchy sketch
  E.anticheat:peer_updated(peer)
end)
Hooks:PostHook(ConnectionNetworkHandler, "lobby_info", "E.anticheat ConnectionNetworkHandler.lobby_info", function(self, level, rank, stinger_index, character, mask_set, sender)
  local peer = self._verify_sender(sender)
  if not peer then return end
  -- E:log("anticheat:", peer:id(), "lobby_info")
  E.anticheat:peer_updated(peer)
end)
Hooks:PostHook(ConnectionNetworkHandler, "sync_player_installed_mod", "E.anticheat ConnectionNetworkHandler.sync_player_installed_mod", function(self, peer_id, mod_id, mod_friendly_name, sender)
  local peer = self._verify_sender(sender)
  if not peer then return end
  -- E:log("anticheat:", peer:id(), "sync_player_installed_mod", mod_id, mod_friendly_name)
  E.anticheat:peer_updated(peer)
end)
