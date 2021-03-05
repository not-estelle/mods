Hooks:PostHook(PlayerStandard, "update", "Custom_crosshairs_PlayerStandard_update", function( self , t , dt )

	-- if self:_is_meleeing() or self:_interacting() then
	-- 	if not self._crosshair_melee then
	-- 		self._crosshair_melee = true
	-- 		managers.hud:set_crosshair_visible( false )
	-- 		managers.hud:set_crosshair_offset( 0 )
	-- 	end
	-- elseif not self:_is_meleeing() and not self:_interacting() then
	-- 	if self._crosshair_melee then
	-- 		self._crosshair_melee = nil
	-- 		managers.hud:set_crosshair_visible( true )
	-- 		self:_update_crosshair_offset( t )
	-- 	end
	-- end
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

-- function PlayerStandard:_update_crosshair_offset( t )
-- 	if not alive( self._equipped_unit ) then return end

-- 	if self:_is_meleeing() or self:_interacting() then
-- 		if self._crosshair_melee then
-- 			managers.hud:set_crosshair_offset( 0 )
-- 			return
-- 		end
-- 	end

-- 	local name_id = self._equipped_unit:base():get_name_id()
-- 	if not tweak_data.weapon[ name_id ].crosshair then
-- 		tweak_data.weapon[ name_id ].crosshair = deep_clone( tweak_data.weapon.glock_17.crosshair )
-- 		return
-- 	end

-- 	if self._state_data.in_steelsight then
-- 		managers.hud:set_crosshair_visible(not tweak_data.weapon[ name_id ].crosshair.steelsight.hidden )
-- 		managers.hud:set_crosshair_offset( tweak_data.weapon[ name_id ].crosshair.steelsight.offset )
-- 		return
-- 	end

-- 	local spread_multiplier = self._equipped_unit:base():spread_multiplier()
-- 	managers.hud:set_crosshair_visible( not tweak_data.weapon[ name_id ].crosshair[ self._state_data.ducking and "crouching" or "standing" ].hidden )

-- 	if self._moving then
-- 		managers.hud:set_crosshair_offset( tweak_data.weapon[ name_id ].crosshair[ self._state_data.ducking and "crouching" or "standing" ].moving_offset * spread_multiplier )
-- 		return
-- 	else
-- 		managers.hud:set_crosshair_offset( tweak_data.weapon[ name_id ].crosshair[ self._state_data.ducking and "crouching" or "standing" ].offset * spread_multiplier )
-- 	end
-- end
