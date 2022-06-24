if E.fast_defaults then return end

E:mod("fast_defaults", {
  defaults = {
    fast_defaults_job_plan = -1, -- any
    fast_defaults_kick_option = 1, -- server
    fast_defaults_permission = "friends_only",
    fast_defaults_drop_in_option = 3, -- stealth_prompt
    fast_defaults_team_ai_option = 1, -- on
    fast_defaults_auto_kick = true, -- on
    fast_defaults_allow_modded_players = true, -- on
    fast_defaults_difficulty_id = 8, -- sm_wish aka ds
    fast_defaults_one_down = false, -- off
  },
  options_menu = {
    {
      type = "multiple_choice",
      option = "fast_defaults_job_plan",
      title = "menu_preferred_plan",
      desc = false,
      choices = {
        {-1, "menu_any"},
        {101, "E_fast_defaults_plan_auto_loud"},
        {102, "E_fast_defaults_plan_auto_stealth"},
        {1, "menu_plan_loud"},
        {2, "menu_plan_stealth"},
      },
    },
    {
      type = "multiple_choice",
      option = "fast_defaults_kick_option",
      title = "menu_kicking_allowed_option",
      desc = false,
      choices = {
        {1, "menu_kick_server"},
        {2, "menu_kick_vote"},
        {0, "menu_kick_disabled"},
      },
    },
    {
      type = "multiple_choice",
      option = "fast_defaults_permission",
      title = "menu_permission",
      desc = false,
      choices = {
        {"public", "menu_public_game"},
        {"friends_only", "menu_friends_only_game"},
        {"private", "menu_private_game"},
      },
    },
    {
      type = "multiple_choice",
      option = "fast_defaults_drop_in_option",
      title = "menu_toggle_drop_in",
      desc = false,
      choices = {
        {0, "menu_off"},
        {1, "menu_drop_in_on"},
        {2, "menu_drop_in_prompt"},
        {3, "menu_drop_in_stealth_prompt"},
      },
    },
    {
      type = "multiple_choice",
      option = "fast_defaults_team_ai_option",
      title = "menu_toggle_ai",
      desc = false,
      choices = {
        {0, "menu_off"},
        {1, "menu_on"},
      },
    },
    {
      type = "toggle",
      option = "fast_defaults_auto_kick",
      title = "menu_toggle_auto_kick",
      desc = false,
    },
    {
      type = "toggle",
      option = "fast_defaults_allow_modded_players",
      title = "menu_toggle_modded_players",
      desc = false,
    },
    { type = "divider", size = 16 },
    {
      type = "multiple_choice",
      option = "fast_defaults_difficulty_id",
      -- en l10n has a colon after this for no reason...
      -- title = "menu_lobby_difficulty_title",
      desc = false,
      choices = {
        {2, "menu_difficulty_normal"},
        {3, "menu_difficulty_hard"},
        {4, "menu_difficulty_very_hard"},
        {5, "menu_difficulty_overkill"},
        {6, "menu_difficulty_easy_wish"},
        {7, "menu_difficulty_apocalypse"},
        {8, "menu_difficulty_sm_wish"},
      },
    },
    {
      type = "toggle",
      option = "fast_defaults_one_down",
      title = "menu_toggle_one_down",
      desc = false,
    },
  },
})

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_E_fast_defaults", function(loc)
  loc:add_localized_strings({
    E_fast_defaults_menu_name = "E: fast defaults",
    E_fast_defaults_menu_desc = "Choose default contract options.",
    E_fast_defaults_difficulty_id_name = "Difficulty",
    E_fast_defaults_plan_auto_stealth = "Auto (Stealth)",
    E_fast_defaults_plan_auto_loud = "Auto (Loud)",
  })
end)
