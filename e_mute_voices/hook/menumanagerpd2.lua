Hooks:PostHook(InspectPlayerInitiator, "modify_node", "E_mute_voices_InspectPlayerInitiator_modify_node", function(self, node, inspect_peer)

  local is_local_peer = inspect_peer == managers.network:session():local_peer()
  if is_local_peer then return end

  local mute_button = self:create_toggle(node, {
    callback = "E_mute_voices_callback",
    text_id = "E_mute_voices_button_name",
    name = "E_mute_voices_button",
    localize = true,
    enabled = true,
    peer = inspect_peer,
  }, E.menu:index_after_item(node, "toggle_mute"))
  mute_button:set_value(inspect_peer.E_voices_muted and "on" or "off")
end)

function MenuCallbackHandler:E_mute_voices_callback(item)
  E.mute_voices:mute_peer(item:parameters().peer, item:value() == "on")
end
