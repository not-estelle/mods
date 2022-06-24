if E.crosshair then return end

E:mod("crosshair", {
  defaults = {
    crosshair_size = 1.7,
    -- crosshair_thickness = 0.75,
    crosshair_offset = 0.75,
    crosshair_alpha = 75,
    crosshair_hue = 0,
    crosshair_sat = 0,
    crosshair_val = 100,
  },
  options_menu = {
    {
      type = "slider",
      option = "crosshair_offset",
      min = 0,
      max = 50,
      step = 1,
    },
    {
      type = "slider",
      option = "crosshair_size",
      min = 0,
      max = 50,
      step = 1,
    },
    { type = "divider" },
    {
      type = "slider",
      option = "crosshair_alpha",
      desc = false,
      min = 0,
      max = 100,
      step = 1,
    },
    {
      type = "slider",
      option = "crosshair_hue",
      desc = false,
      min = 0,
      max = 360,
      step = 1,
    },
    {
      type = "slider",
      option = "crosshair_sat",
      desc = false,
      min = 0,
      max = 100,
      step = 1,
    },
    {
      type = "slider",
      option = "crosshair_val",
      desc = false,
      min = 0,
      max = 100,
      step = 1,
    },
  },
})

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit E.crosshair", function(loc)
  loc:add_localized_strings({
    E_crosshair_menu_name = "E: crosshair",
    E_crosshair_menu_desc = "Customize the appearance of the crosshair.",
    E_crosshair_offset_name = "Crosshair offset",
    E_crosshair_offset_desc = "Offset in pixels of the crosshair.",
    E_crosshair_size_name = "Crosshair size",
    E_crosshair_size_desc = "Size in pixels of the crosshair radius.",
    E_crosshair_thickness_name = "Crosshair thickness",
    E_crosshair_thickness_desc = "Size in pixels of the crosshair thickness.",
    E_crosshair_alpha_name = "Crosshair opacity",
    E_crosshair_hue_name = "Crosshair hue",
    E_crosshair_sat_name = "Crosshair saturation",
    E_crosshair_val_name = "Crosshair value",
  })
end)

function E.crosshair:color()
  if not self._color then
    local alpha = E:get("crosshair_alpha") / 100
    local hue = E:get("crosshair_hue")
    local sat = E:get("crosshair_sat") / 100
    local val = E:get("crosshair_val") / 100
    self._color = Color(alpha, hsv_to_rgb(hue, sat, val))
  end
  return self._color
end

Hooks:Add("E_change", "E_change E.crosshair base", function(name, value)
  if name == "crosshair_alpha" or name == "crosshair_hue" or name == "crosshair_sat" or name == "crosshair_val" then
    E.crosshair._color = nil
  end
end)
