local is_mp = MenuCallbackHandler:is_multiplayer()

if not is_mp then
  -- If it's not multiplayer, then just restart the game
  managers.game_play_central:restart_the_game()
  return
elseif not MenuCallbackHandler:is_server() then
  -- Client, can't do anything
  return
end

local mp_restart_visible = MenuCallbackHandler:_restart_level_visible()

if mp_restart_visible then
  tweak_data.voting.restart_delay = 0
  if managers.vote:option_vote_restart() then
    managers.vote:restart()
  else
    managers.vote:restart_auto()
  end
end
