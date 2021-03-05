Hooks:PostHook(LootDropScreenGui, "init", "Custom_loot_screen_auto_select_LootDropScreenGui_init", function(self)
  self._time_left = -1
  self._fade_time_left = -1
  self:check_all_ready()
end)
