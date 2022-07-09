function HUDLootScreen:check_all_ready()
  -- allow flipping before everyone has chosen
  return true
end

E.fast_end:post_hook(HUDLootScreen, "begin_choose_card", function(self, peer_id, card_id)
  -- auto-flip
  self._peer_data[peer_id].wait_t = 0
end)
E.fast_end:post_hook(HUDLootScreen, "begin_flip_card", function(self, peer_id)
  -- auto-reveal
  self._peer_data[peer_id].wait_t = 0
end)
