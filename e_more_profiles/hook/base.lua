local default_amount = #tweak_data.skilltree.skill_switches
local max_amount = default_amount + 105

E:mod("more_profiles", {
  localize = {
    E_more_profiles_options = "E: more profiles",
    E_more_profiles_options_help = "Adjust the total number of profiles.",
    E_option_more_profiles_amount = "Number of profiles",
    E_option_more_profiles_amount_help = "The number of accessible profiles. Decreasing this will not permanently delete any profile data.",

    E_more_profiles_menu_reset = "Reset all",
    E_more_profiles_menu_reset_help = "Reset and remove all profiles past #" .. default_amount,

    E_more_profiles_reset_title = "Are you sure?",
    E_more_profiles_reset_text = "Are you sure you want to reset and remove all extra profiles?",
  },
  local_defaults = {
    amount = 30,
  },
  options_menu = {
    {
      type = "multi_choice",
      local_option = "amount",
      choices = {
        {default_amount, tostring(default_amount), {localize = false}},
        {default_amount + 15, tostring(default_amount + 15), {localize = false}},
        {default_amount + 30, tostring(default_amount + 30), {localize = false}},
        {default_amount + 45, tostring(default_amount + 45), {localize = false}},
        {default_amount + 60, tostring(default_amount + 60), {localize = false}},
        {default_amount + 75, tostring(default_amount + 75), {localize = false}},
        {default_amount + 90, tostring(default_amount + 90), {localize = false}},
        {max_amount, tostring(max_amount), {localize = false}},
      },
    },
    { type = "divider" },
    {
      type = "button",
      text_id = "E_more_profiles_menu_reset",
      help_id = "E_more_profiles_menu_reset_help",
      callback = "E_more_profiles_reset",
    },
  },
})

E.more_profiles.default_amount = default_amount
E.more_profiles.max_amount = max_amount

function E.more_profiles:init()
  local skill_switch_names = {}
  for i = default_amount + 1, max_amount do
    skill_switch_names["menu_st_skill_switch_" .. i] = "Set #" .. i
  end
  self:localize(skill_switch_names)

  self:fix_skill_tweak()
end
function E.more_profiles:reset_all()
  self:set_option("amount", default_amount)

  local switch_datas = Global.skilltree_manager.skill_switches
  local new_switch_datas = {}
  for i = 1, default_amount do
    new_switch_datas[i] = switch_datas[i]
  end
  Global.skilltree_manager.skill_switches = new_switch_datas

  table.crop(Global.multi_profile._profiles, default_amount)
end

function E.more_profiles:_empty_skill_switch()
  local points = managers.skilltree and managers.skilltree:max_points_for_current_level()
  local switch_data = {
    specialization = false,
    unlocked = true, -- false
    points = Application:digest_value(points or 0, true),
  }
  switch_data.trees = {}

  for tree, data in pairs(tweak_data.skilltree.trees) do
    switch_data.trees[tree] = {
      unlocked = true,
      points_spent = Application:digest_value(0, true),
    }
  end

  switch_data.skills = {}

  for skill_id, data in pairs(tweak_data.skilltree.skills) do
    switch_data.skills[skill_id] = {
      unlocked = 0,
      total = #data,
    }
  end

  return switch_data
end

function E.more_profiles:fix_skill_tweak()
  local amount = self:get("amount")

  local skill_tweak = tweak_data.skilltree.skill_switches
  table.crop(skill_tweak, amount)
  while #skill_tweak < amount do
    local index = #skill_tweak + 1
    table.insert(skill_tweak, {
      name_id = "menu_st_skill_switch_" .. index,
      locks = {
        achievement = "frog_1",
        level = 100,
      },
    })
  end

  local money_tweak = tweak_data.money_manager.skill_switch_cost
  table.crop(money_tweak, amount)
  while #money_tweak < amount do
    table.insert(money_tweak, {
      -- offshore = 20000000,
      offshore = 0,
      spending = 0,
    })
  end
end
function E.more_profiles:fix_skill_global()
  local amount = self:get("amount")

  local switch_datas = Global.skilltree_manager.skill_switches
  local len = #switch_datas
  if amount < len then
    for i = amount + 1, len do
      switch_datas[self:_disabled_key(i)] = switch_datas[i]
      switch_datas[i] = nil
    end
  end
  if len < amount then
    for i = len + 1, amount do
      local key = self:_disabled_key(i)
      switch_datas[i] = switch_datas[key] or self:_empty_skill_switch()
      switch_datas[key] = nil
    end
  end
end
function E.more_profiles:_disabled_key(i)
  return "E_disabled_" .. i
end
function E.more_profiles:switch_if_unsafe()
  local amount = self:get("amount")

  if Global.multi_profile._current_profile > amount then
    managers.multi_profile:set_current_profile(1)
  end
  if Global.skilltree_manager.selected_skill_switch > amount then
    managers.skilltree:switch_skills(1)
  end
  for i = 1, amount do
    local profile = Global.multi_profile._profiles[i]
    if profile and profile.skillset > amount then
      profile.skillset = 1
    end
  end
end

E.more_profiles:hook("E_change", function(name)
  if name == "more_profiles_amount" then
    E.more_profiles:fix_skill_tweak()
    E.more_profiles:fix_skill_global()
    managers.multi_profile:_check_amount()
    E.more_profiles:switch_if_unsafe()
  end
end)

E.more_profiles:init()
