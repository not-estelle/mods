E.fast_end:post_hook(MissionEndState, "at_enter", function(self)
  self._continue_block_timer = 0
end)

E.fast_end:post_hook(MissionEndState, "update", function(self)
  if not self._completion_bonus_done then
    self:set_completion_bonus_done(true)
  end
end)
