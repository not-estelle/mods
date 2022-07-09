E.rejoin:post_hook(SkirmishManager, "on_joined_server", function()
  local lobby_id = managers.network.matchmake.lobby_handler and managers.network.matchmake.lobby_handler:id()
  E.rejoin:set_option("last_lobby_id", lobby_id)
end)
