if E.fast_buy then return end

E:mod("fast_buy", {
  defaults = {
    fast_buy_contract_confirm = false,
    fast_buy_assets_confirm = false,
    fast_buy_assets_auto = true,
  },
  options_menu = {
    {
      type = "toggle",
      option = "fast_buy_contract_confirm",
    },
    { type = "divider", size = 16 },
    {
      type = "toggle",
      option = "fast_buy_assets_confirm",
    },
    {
      type = "toggle",
      option = "fast_buy_assets_auto",
    },
  },
})

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_E_fast_buy", function(loc)
  loc:add_localized_strings({
    E_fast_buy_menu_name = "E: fast buy",
    E_fast_buy_menu_desc = "Purchase assets faster.",
    E_fast_buy_contract_confirm_name = "Confirm contract purchases",
    E_fast_buy_contract_confirm_desc = "Ask before purchasing a contract from the broker.",
    E_fast_buy_assets_confirm_name = "Confirm asset purchases",
    E_fast_buy_assets_confirm_desc = "Ask before purchasing all assets for a day.",
    E_fast_buy_assets_auto_name = "Auto-buy assets",
    E_fast_buy_assets_auto_desc = "Automatically purchase all assets at the briefing screen.",
  })
end)
