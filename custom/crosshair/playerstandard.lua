Hooks:PostHook(PlayerStandard, "update", "Custom_crosshairs_PlayerStandard_update", function( self , t , dt )

	managers.hud:set_crosshair_visible(not self:_interacting())

	if self._fwd_ray and self._fwd_ray.unit then
		local unit = self._fwd_ray.unit

		local function is_teammate( unit )
			for _ , u_data in pairs( managers.groupai:state():all_criminals() ) do
				if u_data.unit == unit then return true end
			end
		end

		if managers.enemy:is_civilian(unit) then
			managers.hud:set_crosshair_color(Color(0.75, 0.7, 1, 0.6))
		elseif managers.enemy:is_enemy(unit) then
			managers.hud:set_crosshair_color(Color(0.75, 1, 0.6, 0.5))
		elseif is_teammate(unit) then
			managers.hud:set_crosshair_color(Color(0.75, 0.6, 0.9, 1))
		else
			managers.hud:set_crosshair_color(Color(0.75, 1, 1, 1))
		end
	else
		managers.hud:set_crosshair_color(Color(0.75, 1, 1, 1))
	end
end)
