if _G.E then return end

_G.E = {}
E._menu_id = "E_menu_id"
E._path = ModPath
E._save_path = SavePath .. "E_data.txt"
E._data = {}
E._defaults = {}
E._mods = {}
E._options_menus = {}

function E:get(name, default)
  local value = self._data and self._data[name]
  if value ~= nil then return value end
  return self._defaults[name] or default
end

function E:set(name, value)
  self._data = self._data or {}
  local old = self._data[name]
  if old == value then return false end
  self._data[name] = value
  -- log("[E] change " .. tostring(name) .. " = " .. tostring(value))
  Hooks:Call("E_change", name, value)
  return true
end
function E:set_option(name, value)
  self:set(name, value)
  self:save()
end

function E:defaults(tab)
  for k,v in pairs(tab) do
    E._defaults[k] = v
  end
end
function E:local_defaults(scope, tab)
  for k,v in pairs(tab) do
    E._defaults[scope .. "_" .. k] = v
  end
end

function E:save()
  if not self._data then return end
  local file = io.open(self._save_path, "w+")
  if file then
    file:write(json.encode(self._data))
    file:close()
  end
end

function E:load()
  local file = io.open(self._save_path, "r")
  if not file then return end
  for key, value in pairs(json.decode(file:read("*a"))) do
    self._data[key] = value
  end
end

E:load()
Hooks:RegisterHook("E_change")

function E:mod(name, opts)
  local mod = {
    name = name,
    _menu_id = "E_" .. name .. "_menu_id",
  }
  local prefix = name .. "_"
  function mod:set_option(k, value)
    E:set_option(prefix .. k, value)
  end
  function mod:get(k, default)
    return E:get(prefix .. k, default)
  end
  E[name] = mod
  table.insert(E._mods, mod)
  if not opts then opts = {} end
  if opts.defaults then
    E:defaults(opts.defaults)
  end
  if opts.local_defaults then
    E:local_defaults(name, opts.local_defaults)
  end
  if opts.options_menu then
    table.insert(E._options_menus, {
      mod = mod,
      menu = opts.options_menu,
    })
  end
end

E.log_level = {
  log = "LOG",
  warn = "WAR",
  error = "ERR",
}
function E:log(...)
  E:_print(E.log_level.log, ...)
end
function E:warn(...)
  E:_print(E.log_level.warn, ...)
end
function E:error(...)
  E:_print(E.log_level.error, ...)
end

function E:_print(level, ...)
  local s = "[E: " .. level .. "] "
  for i, x in ipairs({...}) do
    s = s .. (i > 1 and " " or "") .. E:stringify_shallow(x)
  end
  log(s)
end

function E:stringify_shallow(x, pretty)
  if type(x) == "table" then
    local s = "{"
    local first = true
    for name, value in pairs(x) do
      if first then first = false else s = s .. (pretty and "," or ", ") end
      s = s .. (pretty and "\n  " or "") .. name .. " = " .. tostring(value)
    end
    return s .. (first and "" or pretty and "\n" or "") .. "}"
  else
    return tostring(x)
  end
end

E.menu = {}
function E.menu:insert_item_after(node, new_item, after)
  local index
  if type(after) == "string" then
    index = self:index_after_item(node, after)
  else
    index = after
  end
  node:insert_item(new_item, index or #node._items)
end
function E.menu:index_after_item(node, after)
  for i,item in ipairs(node._items) do
    if after == item._parameters.name then
      return i + 1
    end
  end
end
function E.menu:create_toggle(node, data)
  error "todo"
end
function E.menu:create_divider(node, data)
  return node:create_item({
    type = "MenuItemDivider"
  }, {
    name = "divider_" .. data.id,
    no_text = not data.text_id,
    text_id = data.text_id,
    size = data.size or 8,
    color = data.color,
  })
end

E.commands = {
  _registered = {},
  command_color = tweak_data.screen_colors.mutators_color_text,
  error_color = tweak_data.screen_colors.important_1,
  pagination_color = tweak_data.screen_colors.resource,
}
function E.commands:parse_peer(peer_id)
  if type(peer_id) == "number" then return peer_id end
  local chars = utf8.len(peer_id)
  if string.sub("green", 1, chars) == peer_id then return 1 end
  if string.sub("blue", 1, chars) == peer_id then return 2 end
  if string.sub("red", 1, chars) == peer_id then return 3 end
  if string.sub("yellow", 1, chars) == peer_id then return 4 end
  return nil
end
function E.commands:register(params)
  self._registered[params.name] = params
end
function E.commands:sorted_list()
  local commands = {}
  for name in pairs(self._registered) do
    table.insert(commands, name)
  end
  table.sort(commands)
  return commands
end
function E.commands:help(command, per_page, page)
  if not command then
    self:help_short()
  elseif command == "full" then
    self:help_full(per_page, page)
  else
    self:help_for(command)
  end
end
function E.commands:help_short()
  local list = self:sorted_list()
  local s = {}
  for _,name in ipairs(list) do
    table.insert(s, {#s > 0 and " /" or "/"})
    table.insert(s, {name, E.commands.command_color})
  end
  self:print(s, "equipment_notepad")
end
function E.commands:help_full()
  local list = self:sorted_list()
  self:paginate("E.commands.help_full", #list, per_page, page, function(index)
    local name = list[index]
    local command = self._registered[name]
    return {
      {"/"},
      {name, E.commands.command_color},
      {command.summary and ": " .. command.summary or ""}
    }
  end)
end
function E.commands:help_for(name)
  local command = self._registered[name]
  if not command then
    return
  end
  local usage = command.usage or "$0"
  local heading = {}
  local i = 0
  while true do
    local start = i + 1
    i = string.find(usage, "%$0", start)
    table.insert(heading, {string.sub(usage, start, i and i-1 or string.len(usage))})
    if i == nil then break end
    table.insert(heading, {"/"})
    table.insert(heading, {name, E.commands.command_color})
    i = i + 1 -- advanced from $ to 0
  end
  self:print(heading, "equipment_notepad")
  if command.summary then
    self:print(command.summary)
  end
  if command.description then
    self:print_multi(command.description)
  end
end
function E.commands:print(rich_string, icon)
  -- managers.chat:_receive_message(ChatManager.GAME, "/", message, tweak_data.system_chat_color)
  -- managers.chat:_receive_message(ChatManager.GAME, "", message, tweak_data.system_chat_color)
  managers.chat:E_receive_message(ChatManager.GAME, rich_string, icon)
end
function E.commands:print_error(command, message)
  self:print({{"/"}, {command, E.commands.command_color}, {": "}, {message, E.commands.error_color}})
end
function E.commands:print_multi(message)
  if type(message) == "string" then
    message = string.split(message, "\n")
  end
  for _,line in ipairs(message) do
    self:print(line)
  end
end
function E.commands:process(message)
  if string.len(message) == 0 then return end

  Hooks:Call("E.commands:submit", message)

  local _, last = string.find(message, "^ */")

  if last then
    local message = string.sub(message, last + 1)
    local i = string.find(message, " ", 1, true)
    local command_name = i and string.sub(message, 1, i - 1) or message
    local command_args = i and string.sub(message, i + 1) or ""

    local command = self._registered[command_name]
    if command then
      if command.raw then
        command_args = {command_args}
      else
        command_args = string.split(command_args, " ") or {}
      end
      local status, err = pcall(function()
        command.callback(unpack(command_args))
      end)
      if not status then
        self:print("<internal error: " .. tostring(err) .. ">")
      end
    else
      self:print_error(command_name, "unknown command")
    end

    return true
  else
    return false
  end
end
function E.commands:max_lines()
  local mm = managers.menu_component
  if not mm then return 15 end
  if mm._game_chat_gui then
    return mm._game_chat_gui._max_lines
  else
    return mm._game_chat_params and mm._game_chat_params.max_lines or 15
  end
end

function E.commands:reset_pagination()
  E.commands._paginate_name = nil
  E.commands._paginate_per_page = nil
  E.commands._paginate_next_page = nil
end
E.commands:reset_pagination()
function E.commands:paginate(name, count, per_page, page, item_func)
  if per_page == "all" then
    for i = 1, count do
      E.commands:print(item_func(i))
    end
    return
  end

  if self._paginate_name ~= name then
    self:reset_pagination()
    self._paginate_name = name
  end
  per_page = tonumber(per_page) or E.commands:max_lines() - 1
  page = tonumber(page) or self._paginate_per_page == per_page and self._paginate_next_page or 1
  local page_count = math.ceil(count / per_page)

  if page_count > 1 then
    E.commands:print({{string.format("page %d/%d", page, page_count), E.commands.pagination_color}})
  end

  local start = per_page * (page - 1) + 1
  for i = start, math.min(start + per_page - 1, count) do
    E.commands:print(item_func(i))
  end

  self._paginate_per_page = per_page
  self._paginate_next_page = page == page_count and 1 or page + 1
end

Hooks:RegisterHook("E.commands:submit")

E.commands:register({
  name = "help",
  summary = "list commands",
  usage = "$0 [command] | $0 full",
  callback = callback(E.commands, E.commands, "help"),
})

E.rich_string = {}
function E.rich_string:concatenate(message)
  if type(message) == "string" then
    return message
  else
    local result = ""
    for _,info in ipairs(message) do
      result = result .. tostring(info[1] or info)
    end
    return result
  end
end
function E.rich_string:set_range_colors(line, message)
  if type(message) == "string" then
    local len = utf8.len(message)
    line:set_range_color(0, len, tweak_data.screen_colors.text)
  else
    local i = 0
    -- zero-based, because pd2 hates you
    for _,info in ipairs(message) do
      local msg = tostring(info[1] or info)
      local len = utf8.len(msg)
      local color = info[2]
      if type(color) == "string" then
        color = tweak_data.screen_colors[color]
      end
      line:set_range_color(i, i + len, color or tweak_data.screen_colors.text)
      i = i + len
    end
  end
end
function E.rich_string:get_icon_data(icon)
  if type(icon) == "string" then
    icon = {icon}
  end
  local icon_name, icon_color, default_rect = unpack(icon)
  local icon_texture, icon_texture_rect = tweak_data.hud_icons:get_icon_data(icon_name, default_rect or {0, 0, 16, 16})
  return icon_texture, icon_texture_rect, icon_color
end
function E.rich_string:peer_name(peer)
  local peer_id = peer and peer:id() or 0
  local peer_name = peer and peer:name() or "unknown name"
  local peer_color = tweak_data.chat_colors[peer_id] or tweak_data.chat_colors[#tweak_data.chat_colors]
  return {peer_name, peer_color}
end
function E.rich_string:command(name)
  return {name, E.commands.command_color}
end
function E.rich_string:stringify_shallow(x, pretty)
  if type(x) == "table" then
    local s = {{"{"}}
    local first = true
    for name, value in pairs(x) do
      local comma = first and "" or pretty and "," or ", "
      if first then first = false end
      table.insert(s, {comma .. (pretty and "\n  " or "")})
      table.insert(s, {name, tweak_data.screen_colors.challenge_title})
      table.insert(s, {" = "})
      table.insert(s, {tostring(value), tweak_data.screen_colors.resource})
    end
    table.insert(s, {(first and "" or pretty and "\n" or "") .. "}"})
    return s
  else
    return {{tostring(x), tweak_data.screen_colors.resource}}
  end
end

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus E.crosshair", function(menu_manager, nodes)
  for _,info in ipairs(E._options_menus) do
    MenuHelper:NewMenu(info.mod._menu_id)
  end
end)

function E:_kv_pairs(list)
  local keys = {}
  local values = {}
  for _,pair in ipairs(list) do
    table.insert(keys, pair[1])
    table.insert(values, pair[2])
  end
  return keys, values
end
Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus E.crosshair", function(menu_manager, nodes)
  for _,info in ipairs(E._options_menus) do
    local len = #info.menu
    for i,item in ipairs(info.menu) do
      local priority = len - i + 1
      local menu_id = info.mod._menu_id
      if item.type == "divider" then
        local id = "E_" .. info.mod.name .. "_item" .. tostring(i)
        MenuHelper:AddDivider({
          id = id,
          size = item.size,
          menu_id = menu_id,
          priority = priority,
        })
      else
        local option = item.local_option and info.mod.name .. "_" .. item.local_option or item.option
        if not option then
          E:error("missing option name for item #" .. tostring(i) .. " in " .. info.mod.name)
        else
          local id = "E_" .. option .. "_id"
          local title = item.title or "E_" .. option .. "_name"
          local desc = "E_" .. option .. "_desc"
          if item.desc ~= nil then
            desc = item.desc
          end
          if item.type == "slider" then
            local slider = MenuHelper:AddSlider({
              id = id,
              title = title,
              desc = desc,
              value = E:get(option),
              min = item.min or 1,
              max = item.max or 100,
              step = item.step or 1,
              callback = "E_slider_option",
              menu_id = menu_id,
              priority = priority,
            })
            slider.E_option = option
          elseif item.type == "toggle" then
            local toggle = MenuHelper:AddToggle({
              id = id,
              title = title,
              desc = desc,
              value = E:get(option),
              callback = "E_toggle_option",
              menu_id = menu_id,
              priority = priority,
            })
            toggle.E_option = option
          elseif item.type == "multiple_choice" then
            local values, names = E:_kv_pairs(item.choices)
            local value = table.index_of(values, E:get(option))
            local multiple_choice = MenuHelper:AddMultipleChoice({
              id = id,
              title = title,
              desc = desc,
              items = names,
              value = value,
              callback = "E_multiple_choice_option",
              menu_id = menu_id,
              priority = priority,
            })
            multiple_choice.E_option = option
            multiple_choice.E_values = values
          else
            E:error("invalid menu item type " .. tostring(item.type))
          end
        end
      end
    end
  end
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus E.crosshair", function(menu_manager, nodes)
  for _,info in ipairs(E._options_menus) do
    nodes[info.mod._menu_id] = MenuHelper:BuildMenu(info.mod._menu_id)
    MenuHelper:AddMenuItem(nodes.blt_options, info.mod._menu_id, "E_" .. info.mod.name .. "_menu_name", "E_" .. info.mod.name .. "_menu_desc")
  end
end)

function MenuCallbackHandler:E_slider_option(item)
  E:set_option(item.E_option, item:value())
end
function MenuCallbackHandler:E_toggle_option(item)
  E:set_option(item.E_option, item:value() == "on")
end
function MenuCallbackHandler:E_multiple_choice_option(item)
  E:set_option(item.E_option, item.E_values[item:value()])
end

-- E.MenuData = class(CoreMenuData.Data)

-- E.FAKE_MENU_NAME = "E_fake_menu"

-- function E:open_menu(nodes)
--   local menu = {}
--   menu.data = E.MenuData:new()

--   menu.data._nodes = nodes
--   menu.data:set_callback_handler(MenuCallbackHandler:new())

--   menu.logic = CoreMenuLogic.Logic:new(menu.data)

--   -- menu.logic:register_callback("menu_manager_menu_closed", callback(self, self, "_menu_closed", menu_name))

--   menu.input = MenuInput:new(menu.logic, menu_name)
--   menu.renderer = MenuPauseRenderer:new(menu.logic)

--   menu.renderer:preload()


-- end
