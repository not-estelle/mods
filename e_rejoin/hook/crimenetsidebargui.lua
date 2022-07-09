function CrimeNetSidebarGui:E_rejoin_rejoin()
  local lobby_id = E.rejoin:get("last_lobby_id")
  if not lobby_id then return end
  managers.network.matchmake:join_server_with_check(lobby_id, true)
  -- todo: managers.crime_spree:join_server(job_data)
end

function CrimeNetSidebarGui:clbk_E_rejoin_available()
  return E.rejoin:get("last_lobby_id") and self:clbk_visible_not_in_lobby()
end
