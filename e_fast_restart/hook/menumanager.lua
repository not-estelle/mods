E.fast_restart:pre_hook(MenuCallbackHandler, "restart_level", function()
  -- instantly restart (if we are host)
  tweak_data.voting.restart_delay = 0
end)

function MenuCallbackHandler:_restart_level_visible()
  if not self:is_multiplayer() or self:is_prof_job() then -- or managers.job:stage_success()
    return false
  end

  local state = game_state_machine:current_state_name()
  return state ~= "ingame_lobby_menu" and state ~= "empty" -- changed
end
