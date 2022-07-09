E.ping:post_hook(HUDTeammate, "init", function(self, i, teammates_panel, is_player, width)
  local main_player = i == HUDManager.PLAYER_PANEL
  if main_player then return end

  local ping_text = self._player_panel:text({
    name = "E_ping_text",
    font_size = 9,
    font = "fonts/font_small_noshadow_mf",
    color = Color.white,
    text = "000",
    -- vertical = "top",
    vertical = "bottom",
    -- x = self._player_panel:x(),
    -- y = self._player_panel:child("revive_panel"):bottom(),
  })
end)

local function layout_teammate_panel(self)
  local text = self._player_panel:child("E_ping_text")
  if not text then return end
  -- local revive_panel = self._player_panel:child("revive_panel")
  -- if not revive_panel then return end
  -- text:set_lefttop(self._player_panel:left(), revive_panel:bottom())
  local name_bg = self._panel:child("name_bg")
  if not name_bg then return end
  text:set_leftbottom(name_bg:right() + 2, name_bg:bottom())
end

E.ping:post_hook(HUDTeammate, "set_name", function(self)
  layout_teammate_panel(self)
end)
E.ping:post_hook(HUDTeammate, "set_state", function(self)
  layout_teammate_panel(self)
end)
