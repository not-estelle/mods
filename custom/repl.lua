local orig = ChatGui.enter_key_callback

function ChatGui:enter_key_callback()
  if not self._enabled then return end

  local text = self._input_panel:child("input_text")
  local message = text:text()

  if utf8.sub(message, 1, 2) == "##" then
    local command_string = utf8.sub(message, 3, utf8.len(message))

    local input = "> " .. command_string
    log("[REPL] " .. input)
    managers.chat:feed_system_message(ChatManager.GAME, input)

    local fn, err = loadstring("return " .. command_string, "I")
    local output
    if err then
      output = "> Error: " .. tostring(err);
    else
      local status, result = pcall(fn)
      if status then
        output = "> " .. tostring(result)
      else
        output = "> Error: " .. tostring(result)
      end
    end

    log("[REPL] " .. output)
    managers.chat:feed_system_message(ChatManager.GAME, output)

    text:set_text("")
    text:set_selection(0, 0)
    return
  end

  orig(self)
end
