HUDChat.E_key_binds[Idstring("up"):key()] = function(self, text)
  local message = E.chat_history:prev_item(text:text())
  local len = utf8.len(message)
  text:set_text(message)
  text:set_selection(len, len)
end
HUDChat.E_key_binds[Idstring("down"):key()] = function(self, text)
  local message = E.chat_history:next_item(text:text())
  local len = utf8.len(message)
  text:set_text(message)
  text:set_selection(len, len)
end
