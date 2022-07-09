-- todo: quite fragile, but it's payday's fault

function MenuComponentManager:_create_chat_gui()
  self._preplanning_chat_gui_active = false
  self._lobby_chat_gui_active = false
  self._crimenet_chat_gui_active = false
  self._inventory_chat_gui_active = false

  if self._game_chat_gui then
    self:show_game_chat_gui()
  else
    self:add_game_chat()
  end

  self._game_chat_gui:set_params(self._saved_game_chat_params or "default")

  self._saved_game_chat_params = nil
end

function MenuComponentManager:_create_lobby_chat_gui()
  self._preplanning_chat_gui_active = false
  self._lobby_chat_gui_active = true
  self._crimenet_chat_gui_active = false
  self._inventory_chat_gui_active = false

  if self._game_chat_gui then
    self:show_game_chat_gui()
  else
    self:add_game_chat()
  end

  self._game_chat_gui:set_params(self._saved_game_chat_params or "lobby")

  self._saved_game_chat_params = nil
end

function MenuComponentManager:_create_crimenet_chats_gui()
  self._preplanning_chat_gui_active = false
  self._crimenet_chat_gui_active = true
  self._lobby_chat_gui_active = false
  self._inventory_chat_gui_active = false

  if self._game_chat_gui then
    self:show_game_chat_gui()
  else
    self:add_game_chat()
  end

  self._game_chat_gui:set_params(self._saved_game_chat_params or "crimenet")

  self._saved_game_chat_params = nil
end

function MenuComponentManager:_create_preplanning_chats_gui()
  self._preplanning_chat_gui_active = true
  self._crimenet_chat_gui_active = false
  self._lobby_chat_gui_active = false
  self._inventory_chat_gui_active = false

  if self._game_chat_gui then
    self:show_game_chat_gui()
  else
    self:add_game_chat()
  end

  self._game_chat_gui:set_params(self._saved_game_chat_params or "preplanning")

  self._saved_game_chat_params = nil
end

function MenuComponentManager:_create_inventory_chats_gui(node)
  self._preplanning_chat_gui_active = false
  self._crimenet_chat_gui_active = false
  self._lobby_chat_gui_active = false
  self._inventory_chat_gui_active = true

  if self._game_chat_gui then
    self:show_game_chat_gui()
  else
    self:add_game_chat()
  end

  local params_name = self._saved_game_chat_params or "inventory"

  if node and node:parameters().name == "blackmarket_customize_weapon_color" then
    params_name = self._saved_game_chat_params or "weapon_color_customize"
  end

  self._game_chat_gui:set_params(params_name)

  self._saved_game_chat_params = nil
end
