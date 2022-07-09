E:mod("client_settings", {
  localize = {
    E_client_settings_view_name = "View game settings",
  },
})

function E.client_settings:hook_menu(menu)
  local node = deep_clone(menu.data._nodes.edit_game_settings)
  node:clean_items()
  node:add_item(E.menu:create_multi_choice(node, {
    {-1, "menu_any"},
    {1, "menu_plan_loud"},
    {2, "menu_plan_stealth"},
  }, {
    name = "lobby_job_plan",
    text_id = "menu_preferred_plan",
    help_id = "menu_preferred_plan_help",
  }))
  node:add_item(E.menu:create_multi_choice(node, {
    {0, "menu_kick_disabled"},
    {1, "menu_kick_server"},
    {2, "menu_kick_vote"},
  }, {
    name = "lobby_kicking_allowed_option",
    text_id = "menu_kicking_allowed_option",
    help_id = "menu_kicking_allowed_option_help",
  }))
  node:add_item(E.menu:create_multi_choice(node, {
    {"public", "menu_public_game"},
    {"friends_only", "menu_friends_only_game"},
    {"private", "menu_private_game"},
  }, {
    name = "lobby_permission",
    text_id = "menu_permission",
    help_id = "menu_permission_help",
  }))
  node:add_item(E.menu:create_multi_choice(node, {
    {0, "0", {localize = false}},
    {10, "10", {visible_callback = "reputation_check", localize = false}},
    {20, "20", {visible_callback = "reputation_check", localize = false}},
    {30, "30", {visible_callback = "reputation_check", localize = false}},
    {40, "40", {visible_callback = "reputation_check", localize = false}},
    {50, "50", {visible_callback = "reputation_check", localize = false}},
    {60, "60", {visible_callback = "reputation_check", localize = false}},
    {70, "70", {visible_callback = "reputation_check", localize = false}},
    {80, "80", {visible_callback = "reputation_check", localize = false}},
    {90, "90", {visible_callback = "reputation_check", localize = false}},
    {100, "100", {visible_callback = "reputation_check", localize = false}},
    {110, "110", {visible_callback = "reputation_check", localize = false}},
    {120, "120", {visible_callback = "reputation_check", localize = false}},
    {130, "130", {visible_callback = "reputation_check", localize = false}},
    {140, "140", {visible_callback = "reputation_check", localize = false}},
    {150, "150", {visible_callback = "reputation_check", localize = false}},
    {160, "160", {visible_callback = "reputation_check", localize = false}},
    {170, "170", {visible_callback = "reputation_check", localize = false}},
    {180, "180", {visible_callback = "reputation_check", localize = false}},
    {190, "190", {visible_callback = "reputation_check", localize = false}},
    {193, "193", {visible_callback = "reputation_check", localize = false}},
  }, {
    name = "lobby_reputation_permission",
    text_id = "menu_reputation_permission",
    help_id = "menu_reputation_permission_help",
  }))
  node:add_item(E.menu:create_multi_choice(node, {
    {0, "menu_off"},
    {1, "menu_drop_in_on"},
    {2, "menu_drop_in_prompt"},
    {3, "menu_drop_in_stealth_prompt"},
  }, {
    name = "lobby_drop_in_option",
    text_id = "menu_toggle_drop_in",
    help_id = "menu_toggle_drop_in_help"
  }))
  -- node:add_item(E.menu:create_multi_choice(node, {
  --   {0, "menu_off"},
  --   {1, "menu_on"},
  -- }, {
  --   name="toggle_ai",
  --   text_id="menu_toggle_ai",
  -- }))
  -- node:add_item(E.menu:create_toggle(node, {
  --   name = "toggle_auto_kick",
  --   text_id = "menu_toggle_auto_kick",
  -- }))
  node:add_item(E.menu:create_toggle(node, {
    name = "toggle_allow_modded_players",
    text_id = "menu_toggle_modded_players",
  }))
  node:add_item(E.menu:create_back_button(node))

  menu.data._nodes.E_client_settings = node
  node:parameters().name = "E_client_settings"
  node:parameters().topic_id = "E_client_settings_view_name"
  node:parameters().modifier = {function(node)
    local lobby_data = managers.network.matchmake:get_lobby_data()
    if not lobby_data then return end

    local items = {}

    local lobby_job_plan = node:item("lobby_job_plan")
    if lobby_job_plan then
      lobby_job_plan:set_value(tonumber(lobby_data.job_plan))
      table.insert(items, lobby_job_plan)
    end
    local lobby_kicking_allowed_option = node:item("lobby_kicking_allowed_option")
    if lobby_kicking_allowed_option then
      lobby_kicking_allowed_option:set_value(tonumber(lobby_data.kick_option))
      table.insert(items, lobby_kicking_allowed_option)
    end
    local lobby_permission = node:item("lobby_permission")
    if lobby_permission then
      lobby_permission:set_value(tweak_data:index_to_permission(lobby_data.permission) or "")
      table.insert(items, lobby_permission)
    end
    local lobby_drop_in_option = node:item("lobby_drop_in_option")
    if lobby_drop_in_option then
      lobby_drop_in_option:set_value(tonumber(lobby_data.drop_in))
      table.insert(items, lobby_drop_in_option)
    end
    -- local toggle_ai = node:item("toggle_ai")
    -- if toggle_ai then
    --   toggle_ai:set_value(Global.game_settings.team_ai and "on" or "off")
    --   table.insert(items, toggle_ai)
    -- end
    -- local toggle_auto_kick = node:item("toggle_auto_kick")
    -- if toggle_auto_kick then
    --   toggle_auto_kick:set_value(Global.game_settings.toggle_auto_kick)
    --   table.insert(items, toggle_auto_kick)
    -- end
    local toggle_allow_modded_players = node:item("toggle_allow_modded_players")
    if toggle_allow_modded_players then
      toggle_allow_modded_players:set_value(lobby_data.allow_mods == "1" and "on" or "off")
      table.insert(items, toggle_allow_modded_players)
    end
    local lobby_reputation_permission = node:item("lobby_reputation_permission")
    if lobby_reputation_permission then
      lobby_reputation_permission:set_value(tonumber(lobby_data.min_level))
      table.insert(items, lobby_reputation_permission)
    end

    for _, item in pairs(items) do
      item:parameters().disabled_color = tweak_data.screen_colors.button_stage_3
      item:set_enabled(false)
    end

    return node
  end}
end
function E.client_settings:hook_node(node)
  E.menu:insert_item_after(node, node:create_item(nil, {
    visible_callback = "is_not_server is_multiplayer",
    name = "E_client_settings_view",
    text_id = "E_client_settings_view_name",
    next_node = "E_client_settings",
  }), "edit_game_settings")
end

E.client_settings:hook("MenuManagerPostInitialize", function()
  local menu_pause = managers.menu:get_menu("menu_pause")
  if menu_pause then
    E.client_settings:hook_menu(menu_pause)

    local pause = menu_pause.data._nodes.pause
    if pause then E.client_settings:hook_node(pause) end
  end
  local menu_main = managers.menu:get_menu("menu_main")
  if menu_main then
    E.client_settings:hook_menu(menu_main)

    local nodes = {
      menu_main.data._nodes.lobby,
      menu_main.data._nodes.crime_spree_lobby,
    }
    for _, node in pairs(nodes) do
      if node then E.client_settings:hook_node(node) end
    end
  end
end)
