-- todo: fragile
function MenuManager:toggle_chatinput()
  if Application:editor() then return end
  if SystemInfo:platform() ~= Idstring("WIN32") then return end
  if self:active_menu() then return end
  if not managers.network:session() then return end

  if managers.hud then
    managers.hud:toggle_chatinput()
    return true
  end
end
