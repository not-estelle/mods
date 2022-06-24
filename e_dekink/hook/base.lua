if E.dekink then return end

E:mod("dekink", {
  defaults = {
    dekink_enabled = true,
  },
  options_menu = {
    {
      type = "toggle",
      option = "dekink_enabled",
    },
  },
})
E.dekink.enabled = E:get("dekink_enabled")

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_E_dekink", function(loc)
  loc:add_localized_strings({
    E_dekink_menu_name = "E: dekink",
    E_dekink_menu_desc = "Pretend to be vanilla.",
    E_dekink_enabled_name = "Pretend to be vanilla",
    E_dekink_enabled_desc = "Don't advertise mods to other players.",
  })
end)

Hooks:Add("E_change", "E_change_E_dekink", function(name, value)
    if name == "dekink_enabled" then
        E.dekink.enabled = value
    end
end)
