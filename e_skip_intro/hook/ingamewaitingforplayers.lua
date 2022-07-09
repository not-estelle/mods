E.skip_intro:post_hook(IngameWaitingForPlayersState, "update", function(self)

  if Network:is_server() and not self._skipped then
    managers.hud:blackscreen_skip_circle_done()
    self:_skip()
  end
end)
