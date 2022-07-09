E.crosshair:post_hook(PlayerStandard, "update", function(self, t, dt)
	managers.hud:set_crosshair_visible(not self:_interacting())

	if self._fwd_ray and self._fwd_ray.unit then
		local unit = self._fwd_ray.unit

		local function is_teammate(u_key)
			local state = managers.groupai:state()
			return state._criminals[u_key] or state._converted_police[u_key]
		end
		local function is_police_hostage(u_key)
			local state = managers.groupai:state()
			for _, key in pairs(state:all_hostages()) do
				if u_key == key then return true end
			end
			return false
		end

		local u_key = unit:key()
		if managers.enemy:is_civilian(unit) or is_police_hostage(u_key) then
			managers.hud:set_crosshair_color(Color(0.75, 0.7, 1, 0.6))
		elseif is_teammate(u_key) then
			managers.hud:set_crosshair_color(Color(0.75, 0.6, 0.9, 1))
		elseif managers.enemy:is_enemy(unit) then
			managers.hud:set_crosshair_color(Color(0.75, 1, 0.6, 0.5))
		else
			managers.hud:set_crosshair_color(nil)
		end
	else
		managers.hud:set_crosshair_color(nil)
	end
end)
