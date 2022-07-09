function MultiProfileManager:profile_count()
  return math.max(E.more_profiles:get("amount"), 1)
end

function MultiProfileManager:open_quick_select()
  local dialog_data = {
    title = "",
    text = "",
    button_list = {}
  }

  local profile_count = self:profile_count()
  for idx, profile in ipairs(self._global._profiles) do
    if idx <= profile_count then
      local text = profile.name or "Profile " .. idx

      table.insert(dialog_data.button_list, {
        text = text,
        callback_func = function ()
          self:set_current_profile(idx)
        end,
        focus_callback_func = function ()
        end
      })
    end
  end

  local divider = {
    no_text = true,
    no_selection = true,
  }

  table.insert(dialog_data.button_list, divider)

  local no_button = {
    text = managers.localization:text("dialog_cancel"),
    focus_callback_func = function ()
    end,
    cancel_button = true
  }

  table.insert(dialog_data.button_list, no_button)

  dialog_data.image_blend_mode = "normal"
  dialog_data.text_blend_mode = "add"
  dialog_data.use_text_formating = true
  dialog_data.w = 480
  dialog_data.h = 532
  dialog_data.title_font = tweak_data.menu.pd2_medium_font
  dialog_data.title_font_size = tweak_data.menu.pd2_medium_font_size
  dialog_data.font = tweak_data.menu.pd2_small_font
  dialog_data.font_size = tweak_data.menu.pd2_small_font_size
  dialog_data.text_formating_color = Color.white
  dialog_data.text_formating_color_table = {}
  dialog_data.clamp_to_screen = true

  managers.system_menu:show_buttons(dialog_data)
end

-- really, starbreeze?
function MultiProfileManager:_check_amount()
  local wanted_amount = E.more_profiles:get("amount")

  if not self:current_profile() then
    self:save_current()
  end

  local profile_count = #self._global._profiles
  if wanted_amount < profile_count then
    -- don't actually remove them
    -- table.crop(self._global._profiles, wanted_amount)

    self._global._current_profile = math.min(self._global._current_profile, wanted_amount)
  elseif profile_count < wanted_amount then
    local prev_current = self._global._current_profile
    local prev_skillset = self:current_profile().skillset
    self._global._current_profile = profile_count

    while self._global._current_profile < wanted_amount do
      self._global._current_profile = self._global._current_profile + 1
      managers.skilltree:switch_skills(self._global._current_profile)

      self:save_current()
    end

    managers.skilltree:switch_skills(prev_skillset)
    self._global._current_profile = prev_current
  end
end
