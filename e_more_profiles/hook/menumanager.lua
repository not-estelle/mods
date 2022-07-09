function MenuCallbackHandler:E_more_profiles_reset()
  local dialog_data = {
    title = managers.localization:text("E_more_profiles_reset_title"),
    text = managers.localization:text("E_more_profiles_reset_text"),
  }
  local yes_button = {
    text = managers.localization:text("dialog_yes"),
    callback_func = callback(self, self, "E_more_profiles_reset_yes"),
  }
  local no_button = {
    text = managers.localization:text("dialog_no"),
    callback_func = function ()
      self:refresh_node()
    end,
    cancel_button = true,
  }
  dialog_data.button_list = {
    yes_button,
    no_button,
  }

  managers.system_menu:show(dialog_data)
end

function MenuCallbackHandler:E_more_profiles_reset_yes()
  E.more_profiles:reset_all()
  self:refresh_node()
end
