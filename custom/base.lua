if _G.Custom then return end

_G.Custom = {}
Custom._menu_id = "Custom_menu_id"
Custom._path = ModPath
Custom._save_path = SavePath .. "Custom_data.txt"
Custom._data = {
  crosshair_size = 10,
  crosshair_offset = 5,
}

function Custom:get(name, default)
  return self._data and self._data[name] or default
end

function Custom:set(name, value)
  self._data = self._data or {}
  local old = self._data[name]
  if old == value then return false end
  self._data[name] = value
  -- log("[Custom] change " .. tostring(name) .. " = " .. tostring(value))
  Hooks:Call("Custom_change", name, value)
  return true
end
function Custom:set_option(name, value)
  self:set(name, value)
  self:save()
end

function Custom:save()
  if not self._data then return end
  local file = io.open(self._save_path, "w+")
  if file then
    file:write(json.encode(self._data))
    file:close()
  end
end

function Custom:load()
  local file = io.open(self._save_path, "r")
  if not file then return end
  for key, value in pairs(json.decode(file:read("*a"))) do
    self._data[key] = value
  end
end

Custom:load()
Hooks:RegisterHook("Custom_change")

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_Custom", function(loc)
  loc:add_localized_strings({
    Custom_menu_name = "Custom",
    Custom_menu_desc = "Customizations mod",
    Custom_crosshair_offset_name = "Crosshair offset",
    Custom_crosshair_offset_desc = "Offset in pixels of crosshair",
    Custom_crosshair_size_name = "Crosshair size",
    Custom_crosshair_size_desc = "Size in pixels of crosshair",
  })
end)

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_Custom", function(menu_manager, nodes)
  MenuHelper:NewMenu(Custom._menu_id)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_Custom", function(menu_manager, nodes)

  MenuCallbackHandler.Custom_crosshair_offset = function(self, item)
    Custom:set_option("crosshair_offset", item:value())
  end
  MenuHelper:AddSlider({
    id = "Custom_crosshair_offset",
    title = "Custom_crosshair_offset_name",
    desc = "Custom_crosshair_offset_desc",
    value = Custom:get("crosshair_offset"),
    min = 0,
    max = 50,
    step = 1,
    callback = "Custom_crosshair_offset",
    menu_id = Custom._menu_id,
  })

  MenuCallbackHandler.Custom_crosshair_size = function(self, item)
    Custom:set_option("crosshair_size", item:value())
  end
  MenuHelper:AddSlider({
    id = "Custom_crosshair_size",
    title = "Custom_crosshair_size_name",
    desc = "Custom_crosshair_size_desc",
    value = Custom:get("crosshair_size"),
    min = 0,
    max = 50,
    step = 1,
    callback = "Custom_crosshair_size",
    menu_id = Custom._menu_id,
  })
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_Custom", function(menu_manager, nodes)
  nodes[Custom._menu_id] = MenuHelper:BuildMenu(Custom._menu_id)
  MenuHelper:AddMenuItem(nodes.blt_options, Custom._menu_id, "Custom_menu_name", "Custom_menu_desc")
end)
