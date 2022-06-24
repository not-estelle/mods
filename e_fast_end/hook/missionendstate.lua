Hooks:PostHook(MissionEndState, "at_enter", "E_fast_end_MissionEndState_at_enter", function(self)
  self._continue_block_timer = 0
end)

Hooks:PostHook(MissionEndState, "update", "E_fast_end_MissionEndState_update", function(self)
  if not self._completion_bonus_done then
    self:set_completion_bonus_done(true)
  end
end)
