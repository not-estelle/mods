function ChatManager:feed_system_message(channel_id, message)
  self:E_receive_message(channel_id, {{message}}, {"pd2_generic_look", tweak_data.system_chat_color})
end

function ChatManager:E_receive_message(channel_id, rich_string, icon)
  if not self._receivers[channel_id] then return end

  for i, receiver in ipairs(self._receivers[channel_id]) do
    if receiver.E_receive_message then
      receiver:E_receive_message(rich_string, icon)
    end
  end
end

local enter_key_callback = ChatGui.enter_key_callback
function ChatGui:enter_key_callback()
  if not self._enabled then return end

  local text = self._input_panel:child("input_text")
  local message = text:text()

  if E.commands:process(message) then
    text:set_text("")
    text:set_selection(0, 0)
    return
  end

  enter_key_callback(self)
end

function ChatGui:E_receive_message(rich_string, icon)
  if not alive(self._panel) or not managers.network:session() then
    return
  end

  local output_panel = self._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  local local_peer = managers.network:session():local_peer()
  local peers = managers.network:session():peers()
  local len = utf8.len(name) + 1
  local x = 0
  local icon_bitmap = nil

  if icon then
    local icon_texture, icon_texture_rect, icon_color = E.rich_string:get_icon_data(icon)
    local h = 16
    local w = h * (icon_texture_rect[3] or 1) / (icon_texture_rect[4] or 1)
    icon_bitmap = scroll_panel:bitmap({
      y = 1,
      texture = icon_texture,
      texture_rect = icon_texture_rect,
      color = icon_color or tweak_data.screen_colors.text,
      h = h,
      w = w,
    })
    x = icon_bitmap:right()
  end

  local line = scroll_panel:text({
    halign = "left",
    vertical = "top",
    hvertical = "top",
    wrap = true,
    align = "left",
    blend_mode = "normal",
    word_wrap = true,
    y = 0,
    layer = 0,
    text = E.rich_string:concatenate(rich_string),
    font = tweak_data.menu.pd2_small_font,
    font_size = tweak_data.menu.pd2_small_font_size,
    x = x,
    w = scroll_panel:w() - x,
    color = tweak_data.screen_colors.text,
  })
  E.rich_string:set_range_colors(line, rich_string)

  local _, _, w, h = line:text_rect()
  line:set_h(h)

  local line_bg = scroll_panel:rect({
    hvertical = "top",
    halign = "left",
    layer = -1,
    color = Color.black:with_alpha(0.5)
  })

  line_bg:set_h(h)
  line:set_kern(line:kern())
  table.insert(self._lines, {
    line,
    line_bg,
    icon_bitmap
  })
  self:_layout_output_panel()

  if not self._focus then
    output_panel:stop()
    output_panel:animate(callback(self, self, "_animate_show_component"), output_panel:alpha())
    output_panel:animate(callback(self, self, "_animate_fade_output"))
    self:start_notify_new_message()
  end
end

Hooks:PostHook(ChatGui, "loose_focus", "E.base ChatGui:loose_focus", function(self)
  if managers.menu then
    managers.menu:input_enabled(true)
  end
end)
