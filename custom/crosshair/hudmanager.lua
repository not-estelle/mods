Hooks:PostHook( HUDManager , "_player_hud_layout" , "Custom_crosshairs_HUDManager_layout" , function( self )

  self._crosshair_main = managers.hud:script( PlayerBase.PLAYER_INFO_HUD_PD2 ).panel:panel({
    name  = "crosshair_main",
    halign  = "grow",
    valign  = "grow"
  })

  local crosshair_panel = self._crosshair_main:panel({
    name = "crosshair_panel"
  })

  local crosshair_part_left = crosshair_panel:rect({
    name = "crosshair_part_left",
    valign = "scale",
    halign = "scale",
    blend_mode = "normal",
    w = 20,
    h = 1,
  })
  local crosshair_part_right = crosshair_panel:rect({
    name = "crosshair_part_right",
    valign = "scale",
    halign = "scale",
    blend_mode = "normal",
    w = 20,
    h = 1,
  })
  local crosshair_part_top = crosshair_panel:rect({
    name = "crosshair_part_top",
    valign = "scale",
    halign = "scale",
    blend_mode = "normal",
    w = 1,
    h = 20,
  })
  local crosshair_part_bottom = crosshair_panel:rect({
    name = "crosshair_part_bottom",
    valign = "scale",
    halign = "scale",
    blend_mode = "normal",
    w = 1,
    h = 20,
  })

  crosshair_panel:set_center( managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:center() )

  self._ch_size = Custom:get("crosshair_size", 0)
  self._ch_offset = Custom:get("crosshair_offset", 0)
  self:_layout_crosshair()

end )

function HUDManager:set_crosshair_offset(offset)
  self._ch_offset = offset
  self:_layout_crosshair()
end

function HUDManager:set_crosshair_size(size)
  self._ch_size = size
  self:_layout_crosshair()
end

function HUDManager:set_crosshair_color( color )
  if not self._crosshair_main then return end

  self._crosshair_parts = self._crosshair_parts or {
    self._crosshair_main:child( "crosshair_panel" ):child( "crosshair_part_left" ),
    self._crosshair_main:child( "crosshair_panel" ):child( "crosshair_part_top" ),
    self._crosshair_main:child( "crosshair_panel" ):child( "crosshair_part_right" ),
    self._crosshair_main:child( "crosshair_panel" ):child( "crosshair_part_bottom" )
  }

  for _ , part in ipairs( self._crosshair_parts ) do
    part:set_color( color )
  end
end

function HUDManager:show_crosshair_panel( visible )
  if not self._crosshair_main then return end

  self._crosshair_main:set_visible( visible )
end

function HUDManager:set_crosshair_visible( visible )
  if not self._crosshair_main then return end

  if visible and not self._crosshair_visible then
    self._crosshair_visible = true
    self._crosshair_main:child("crosshair_panel"):set_visible(true)

  elseif not visible and self._crosshair_visible then
    self._crosshair_visible = nil
    self._crosshair_main:child("crosshair_panel"):set_visible(false)
  end
end

function HUDManager:_layout_crosshair()
  if not self._crosshair_main then return end

  local hud = self._crosshair_main
  local x = self._crosshair_main:child("crosshair_panel"):center_x() - self._crosshair_main:child("crosshair_panel"):left()
  local y = self._crosshair_main:child("crosshair_panel"):center_y() - self._crosshair_main:child("crosshair_panel"):top()
  local size = self._ch_size
  local offset = self._ch_offset


  self._crosshair_left = self._crosshair_left or self._crosshair_main:child("crosshair_panel"):child("crosshair_part_left")
  self._crosshair_left:set_w(size)
  self._crosshair_left:set_right(x - offset)
  self._crosshair_left:set_center_y(y)

  self._crosshair_right = self._crosshair_right or self._crosshair_main:child("crosshair_panel"):child("crosshair_part_right")
  self._crosshair_right:set_w(size)
  self._crosshair_right:set_left(x + offset)
  self._crosshair_right:set_center_y(y)

  self._crosshair_top = self._crosshair_top or self._crosshair_main:child("crosshair_panel"):child("crosshair_part_top")
  self._crosshair_top:set_h(size)
  self._crosshair_top:set_center_x(x)
  self._crosshair_top:set_bottom(y - offset)

  self._crosshair_bottom = self._crosshair_bottom or self._crosshair_main:child("crosshair_panel"):child("crosshair_part_bottom")
  self._crosshair_bottom:set_h(size)
  self._crosshair_bottom:set_center_x(x)
  self._crosshair_bottom:set_top(y + offset)
end

Hooks:Add("Custom_change", "Custom_crosshair_Custom_change", function(name, value)
  if name == "crosshair_offset" then
    managers.hud:set_crosshair_offset(value)
  end
  if name == "crosshair_size" then
    managers.hud:set_crosshair_size(value)
  end
end)
