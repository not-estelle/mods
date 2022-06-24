E:mod("blank_lobby", {})

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit E.blank_lobby", function(loc)
  loc:add_localized_strings({
    E_blank_lobby_create_name = "Create lobby",
  })
end)
