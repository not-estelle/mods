E.crosshair:post_hook(PlayerMovement, "change_state", function(self, name)
  local s = self._current_state_name
  managers.hud:show_crosshair_panel(s == "standard" or s == "bleed_out" or s == "carry" or s == "bipod")
end)
