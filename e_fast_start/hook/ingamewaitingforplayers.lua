E.fast_start:post_hook(IngameWaitingForPlayersState, "update", function(self, t, dt)
  if self._delay_start_t then
    self._delay_start_t = t - 1
  end
  if self._delay_spawn_t then
    self._delay_spawn_t = t - 1
  end
end)
