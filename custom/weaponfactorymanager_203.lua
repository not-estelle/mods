function WeaponFactoryManager:_spawn_and_link_unit(u_name, a_obj, third_person, link_to_unit)
  if tostring(u_name) == "Idstring(@IDa1723319fa2ec5c9@)" then
    log(tostring(u_name:t()))
    log(tostring(u_name:key()))
    log(tostring(u_name:raw()))
    return self:_spawn_and_link_unit(_G._patch_203_1_last, a_obj, third_person, link_to_unit)
  end
  _G._patch_203_1_last = u_name
  local unit = World:spawn_unit(u_name, Vector3(), Rotation())
  local res = link_to_unit:link(a_obj, unit, unit:orientation_object():name())

  if managers.occlusion and not third_person then
    managers.occlusion:remove_occlusion(unit)
  end

  return unit
end
