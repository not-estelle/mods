local original_say = UnitNetworkHandler.say
function UnitNetworkHandler:say(unit, event_id, sender)
  local peer = self._verify_sender(sender)
  if E.mute_voices:is_peer_muted(peer) then return end

  original_say(self, unit, event_id, sender)
end

local original_unit_sound_play = UnitNetworkHandler.unit_sound_play
function UnitNetworkHandler:unit_sound_play(unit, event_id, source, sender)
  local peer = self._verify_sender(sender)
  if E.mute_voices:is_peer_muted(peer) then return end

  original_unit_sound_play(self, unit, event_id, source, sender)
end

local original_corpse_sound_play = UnitNetworkHandler.corpse_sound_play
function UnitNetworkHandler:corpse_sound_play(unit_id, event_id, source, sender)
  local peer = self._verify_sender(sender)
  if E.mute_voices:is_peer_muted(peer) then return end

  original_corpse_sound_play(self, unit_id, event_id, source)
end
