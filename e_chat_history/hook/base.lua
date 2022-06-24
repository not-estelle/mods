if E.chat_history then return end

E:mod("chat_history", {
  defaults = {
    chat_history_max_lines = 1000,
  },
})

E.chat_history._history = {}
E.chat_history._index = nil
E.chat_history._remembered = nil

function E.chat_history:next_item(message)
  local index = message ~= "" and self._index or nil
  if index then index = index + 1 end

  local history = self:history()
  if index and index > #history then
    self._index = nil
    local remembered = self._remembered
    self._remembered = nil
    return remembered
  end
  self._index = index
  return index and history[index] or message
end

function E.chat_history:prev_item(message)
  local index = message ~= "" and self._index or nil
  local history = self:history()
  if index then
    index = math.max(1, index - 1)
  else
    index = #history
    if index == 0 then
      index = nil
    end
    self._remembered = message
  end

  self._index = index
  return index and history[index] or message
end

function E.chat_history:history()
  return self._history
end

function E.chat_history:_submit(message)
  table.insert(self._history, message)
  if #self._history > E:get("chat_history_max_lines") then
    table.remove(self._history, 1)
  end
  self._index = nil
  self._remembered = nil
end

Hooks:Add("E.commands:submit", "E.chat_history E.commands:submit", callback(E.chat_history, E.chat_history, "_submit"))
