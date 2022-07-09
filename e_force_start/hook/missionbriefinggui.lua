E.force_start:post_hook(MissionBriefingGui, "init", function(self)

  self._force_start_button = self._panel:text({
    vertical = "center",
    name = "ready_button",
    blend_mode = "add",
    align = "right",
    rotation = 360,
    layer = 2,
    text = managers.localization:text("E_force_start_name"),
    font_size = tweak_data.menu.pd2_medium_font_size,
    font = tweak_data.menu.pd2_medium_font,
    color = tweak_data.screen_colors.button_stage_3
  })

  local _, _, w, h = self._force_start_button:text_rect()
  self._force_start_button:set_size(w, h)


  self._force_start_button:set_bottom(self._ready_button:top())
  self._force_start_button:set_right(self._ready_tick_box:right())

  self._force_start_confirm = false
end)

E.force_start:post_hook(MissionBriefingGui, "mouse_pressed", function(self, button, x, y)

  if not alive(self._panel) or not alive(self._fullscreen_panel) or not self._enabled then
    return
  end

  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return
  end

  if self._displaying_asset or button ~= Idstring("0") then return end

  if self._force_start_button:inside(x, y) then
    if self._force_start_confirm then
      for k, peer in pairs(managers.network:session():peers()) do
        if not peer:synched() then return end
      end
      game_state_machine:current_state():start_game_intro()
    else
      self._force_start_confirm = true
      self._force_start_button:set_text(managers.localization:text("E_force_start_confirm"))
    end
  end
end)

E.force_start:post_hook(MissionBriefingGui, "mouse_moved", function(self, x, y)

  if not alive(self._panel) or not alive(self._fullscreen_panel) or not self._enabled or self._displaying_asset or game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return
  end

  if self._force_start_button:inside(x, y) then
    if not self._force_start_highlighted then
      self._force_start_highlighted = true
      self._force_start_button:set_color(tweak_data.screen_colors.button_stage_2)
      managers.menu_component:post_event("highlight")
    end

    return true, "link"
  elseif self._force_start_highlighted then
    self._force_start_highlighted = false
    self._force_start_button:set_color(tweak_data.screen_colors.button_stage_3)

    if self._force_start_confirm then
      self._force_start_confirm = false
      self._force_start_button:set_text(managers.localization:text("E_force_start_name"))
    end
  end
end)
