if E.blame then return end

E:mod("blame", {})

function E.blame:notify_by_player(player, message)
  local session = managers.network:session()
  if not session then return end
  local peer = session:peer_by_unit(player)
  if not peer then return end
  self:notify_by_peer(peer, message)
end
function E.blame:notify_by_peer(peer, message)
  local message = {
    E.rich_string:peer_name(peer),
    {" " .. message, E.commands.error_color},
  }
  E.commands:print(message, "equipment_timer")
end
