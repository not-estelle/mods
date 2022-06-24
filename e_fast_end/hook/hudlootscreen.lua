function HUDLootScreen:check_all_ready()
  -- allow flipping before everyone has chosen
  return true
end

Hooks:PostHook(HUDLootScreen, "begin_choose_card", "E_fast_end_HUDLootScreen_begin_choose_card", function(self, peer_id, card_id)
  -- auto-flip
  self._peer_data[peer_id].wait_t = 0
end)
Hooks:PostHook(HUDLootScreen, "begin_flip_card", "E_fast_end_HUDLootScreen_begin_flip_card", function(self, peer_id)
  -- auto-reveal
  self._peer_data[peer_id].wait_t = 0
end)
