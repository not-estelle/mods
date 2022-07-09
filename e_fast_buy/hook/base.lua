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
    { type = "divider" },
    {
      type = "toggle",
      option = "fast_buy_assets_confirm",
    },
    {
      type = "toggle",
      option = "fast_buy_assets_auto",
    },
  },
  localize = {
    E_fast_buy_options = "E: fast buy",
    E_fast_buy_options_help = "Purchase assets faster.",
    E_option_fast_buy_contract_confirm = "Confirm contract purchases",
    E_option_fast_buy_contract_confirm_help = "Ask before purchasing a contract from the broker.",
    E_option_fast_buy_assets_confirm = "Confirm asset purchases",
    E_option_fast_buy_assets_confirm_help = "Ask before purchasing all assets for a day.",
    E_option_fast_buy_assets_auto = "Auto-buy assets",
    E_option_fast_buy_assets_auto_help = "Automatically purchase all assets at the briefing screen.",
  },
})
