E:mod("rejoin", {
  localize = {
    E_rejoin_menu = "Rejoin lobby",
  },
})

for i, item in ipairs(tweak_data.gui.crime_net.sidebar) do
  if item.name_id == "menu_cn_premium_buy" then
    table.insert(tweak_data.gui.crime_net.sidebar, i + 1, {
      visible_callback = "clbk_E_rejoin_available",
      name_id = "E_rejoin_menu",
      icon = "pd2_power",
      callback = "E_rejoin_rejoin",
    })
    break
  end
end
