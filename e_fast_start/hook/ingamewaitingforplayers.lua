Hooks:PostHook(IngameWaitingForPlayersState, "update", "E_fast_start_IngameWaitingForPlayersState_update", function(self, t, dt)
  if self._delay_start_t then
    self._delay_start_t = t - 1
  end
  if self._delay_spawn_t then
    self._delay_spawn_t = t - 1
  end
end)
