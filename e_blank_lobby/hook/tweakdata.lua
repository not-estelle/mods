for i, item in ipairs(tweak_data.gui.crime_net.sidebar) do
  if item.name_id == "menu_cn_premium_buy" then
    table.insert(tweak_data.gui.crime_net.sidebar, i + 1, {
      visible_callback = "clbk_visible_multiplayer",
      name_id = "E_blank_lobby_create_name",
      icon = "icon_addon",
      callback = "E_blank_lobby_create",
    })
  end
end
