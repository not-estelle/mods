if E.mute_voices then return end

E:mod("mute_voices", {})

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_E_mute_voices", function(loc)
  loc:add_localized_strings({
    E_mute_voices_button_name = "Mute Voices",
  })
end)

function E.mute_voices:mute_peer(peer, muted)
  peer.E_voices_muted = muted
end

function E.mute_voices:is_peer_muted(peer)
  return peer and peer.E_voices_muted
end
