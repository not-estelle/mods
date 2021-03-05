Hooks:PostHook( PlayerMovement , "change_state" , "DynamicCrosshairsPostPlayerMovementChangeState" , function( self , name )

  local s = self._current_state_name
  managers.hud:show_crosshair_panel( s == "standard" or s == "bleed_out" or s == "carry" or s == "bipod" )
end)
