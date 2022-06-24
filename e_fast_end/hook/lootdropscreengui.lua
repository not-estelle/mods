Hooks:PostHook(LootDropScreenGui, "init", "E_fast_end_LootDropScreenGui_init", function(self)
  -- allow instant ENTER to advance
  self._time_left = -1
  self._fade_time_left = -1
  self:check_all_ready()
end)
