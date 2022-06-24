local modify_node = MenuCrimeNetContractInitiator.modify_node
function MenuCrimeNetContractInitiator:modify_node(original_node, data)
  local node = deep_clone(original_node)
  if data.customize_contract then
    -- local difficulty = E:get("fast_defaults_difficulty")
    -- local difficulty_id = tweak_data:difficulty_to_index(difficulty)
    local difficulty_id = E:get("fast_defaults_difficulty_id")
    local difficulty = tweak_data:index_to_difficulty(difficulty_id)
    data.difficulty = difficulty
    data.difficulty_id = difficulty_id
    node:item("difficulty"):set_value(difficulty_id)
  end
  local is_new_lobby = not data.server and not managers.network:session()
  if is_new_lobby then
    local job_plan = E:get("fast_defaults_job_plan")
    if job_plan == 101 or job_plan == 102 then
      local can_stealth = false
      local can_loud = true
      if data.job_id == "mallcrasher" then
        -- ;)
        can_stealth = true
      else
        local job_tweak = data.job_id and tweak_data.narrative:job_data(data.job_id)
        local wrapped_tweak = job_tweak and job_tweak.job_wrapper and tweak_data.narrative.jobs[job_tweak.job_wrapper[1]]
        local chain = wrapped_tweak and wrapped_tweak.chain or job_tweak and job_tweak.chain
        if chain then
          for _, data in ipairs(chain) do
            local level_data = tweak_data.levels[data.level_id]
            if level_data then
              if level_data.ghost_required or level_data.ghost_required_visual then
                can_loud = false
                can_stealth = true
              elseif level_data.ghost_bonus == nil then
                can_loud = true
              elseif level_data.ghost_bonus ~= nil then
                can_stealth = true
              end
            end
          end
        else
          -- empty lobby or other nonsense
          can_stealth = true
        end
      end

      job_plan = job_plan == 102 and (can_stealth and 2 or 1) or (can_loud and 1 or 2)
    end
    Global.game_settings.job_plan = job_plan
    Global.game_settings.kick_option = E:get("fast_defaults_kick_option")
    Global.game_settings.permission = E:get("fast_defaults_permission")
    local drop_in_option = E:get("fast_defaults_drop_in_option")
    Global.game_settings.drop_in_allowed = drop_in_option ~= 0
    Global.game_settings.drop_in_option = drop_in_option
    local team_ai_option = E:get("fast_defaults_team_ai_option")
    Global.game_settings.team_ai = team_ai ~= 0
    Global.game_settings.team_ai_option = team_ai_option
    Global.game_settings.auto_kick = E:get("fast_defaults_auto_kick")
    Global.game_settings.allow_modded_players = E:get("fast_defaults_allow_modded_players")
  end
  node = modify_node(self, node, data)
  if data.customize_contract then
    local one_down = E:get("fast_defaults_one_down")
    Global.game_settings.one_down = one_down
    -- base code just unconditionally sets this to off...
    node:item("toggle_one_down"):set_value(one_down and "on" or "off")
  end
  return node
end
