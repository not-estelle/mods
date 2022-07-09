E.ping:post_hook(HUDManager, "update", function(self, t, dt)
  E.ping:update_pings(t, dt)
end)
