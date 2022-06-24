if _G.E.force_start then return end

E.force_start = {}

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_E_force_start", function(loc)
  loc:add_localized_strings({
    E_force_start_name = "FORCE START",
    E_force_start_confirm = "FORCE START?",
  })
end)