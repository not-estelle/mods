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
  localize = {
    E_fast_defaults_options = "E: fast defaults",
    E_fast_defaults_options_help = "Choose default contract options.",
    E_option_fast_defaults_difficulty_id = "Difficulty",
    E_fast_defaults_plan_auto_stealth = "Auto (Stealth)",
    E_fast_defaults_plan_auto_loud = "Auto (Loud)",
  },
  options_menu = {
    {
      type = "multi_choice",
      option = "fast_defaults_job_plan",
      text_id = "menu_preferred_plan",
      help_id = "menu_preferred_plan_help",
      choices = {
        {-1, "menu_any"},
        {101, "E_fast_defaults_plan_auto_loud"},
        {102, "E_fast_defaults_plan_auto_stealth"},
        {1, "menu_plan_loud"},
        {2, "menu_plan_stealth"},
      },
    },
    {
      type = "multi_choice",
      option = "fast_defaults_kick_option",
      text_id = "menu_kicking_allowed_option",
      help_id = false,
      choices = {
        {1, "menu_kick_server"},
        {2, "menu_kick_vote"},
        {0, "menu_kick_disabled"},
      },
    },
    {
      type = "multi_choice",
      option = "fast_defaults_permission",
      text_id = "menu_permission",
      help_id = "menu_permission_help",
      choices = {
        {"public", "menu_public_game"},
        {"friends_only", "menu_friends_only_game"},
        {"private", "menu_private_game"},
      },
    },
    {
      type = "multi_choice",
      option = "fast_defaults_drop_in_option",
      text_id = "menu_toggle_drop_in",
      help_id = "menu_toggle_drop_in_help",
      choices = {
        {0, "menu_off"},
        {1, "menu_drop_in_on"},
        {2, "menu_drop_in_prompt"},
        {3, "menu_drop_in_stealth_prompt"},
      },
    },
    {
      type = "multi_choice",
      option = "fast_defaults_team_ai_option",
      text_id = "menu_toggle_ai",
      help_id = false,
      choices = {
        {0, "menu_off"},
        {1, "menu_on"},
      },
    },
    {
      type = "toggle",
      option = "fast_defaults_auto_kick",
      text_id = "menu_toggle_auto_kick",
      help_id = false,
    },
    {
      type = "toggle",
      option = "fast_defaults_allow_modded_players",
      text_id = "menu_toggle_modded_players",
      help_id = false,
    },
    { type = "divider", size = 16 },
    {
      type = "multi_choice",
      option = "fast_defaults_difficulty_id",
      -- en l10n has a colon after this for no reason...
      -- text_id = "menu_lobby_difficulty_title",
      help_id = false,
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
      text_id = "menu_toggle_one_down",
      help_id = false,
    },
  },
})
