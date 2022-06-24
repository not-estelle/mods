local enter_key_callback = HUDChat.enter_key_callback
function HUDChat:enter_key_callback()
  local text = self._input_panel:child("input_text")
  local message = text:text()

  if E.commands:process(message) then
    text:set_text("")
    text:set_selection(0, 0)
    managers.hud:set_chat_focus(false)
    return
  end

  enter_key_callback(self)
end

function HUDChat:E_receive_message(rich_string, icon)
  local output_panel = self._panel:child("output_panel")
  local len = utf8.len(name) + 1
  local x = 0
  local icon_bitmap = nil

  if icon then
    local icon_texture, icon_texture_rect, icon_color = E.rich_string:get_icon_data(icon)
    local h = 16
    local w = h * (icon_texture_rect[3] or 1) / (icon_texture_rect[4] or 1)
    icon_bitmap = output_panel:bitmap({
      y = 1,
      texture = icon_texture,
      texture_rect = icon_texture_rect,
      color = icon_color or tweak_data.screen_colors.text,
      h = h,
      w = w,
    })
    x = icon_bitmap:right()
  end

  local line = output_panel:text({
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
    color = tweak_data.screen_colors.text,
  })
  E.rich_string:set_range_colors(line, rich_string)

  local _, _, w, h = line:text_rect()

  line:set_h(h)
  table.insert(self._lines, {
    line,
    icon_bitmap
  })
  line:set_kern(line:kern())
  self:_layout_output_panel()

  if not self._focus then
    local output_panel = self._panel:child("output_panel")

    output_panel:stop()
    output_panel:animate(callback(self, self, "_animate_show_component"), output_panel:alpha())
    output_panel:animate(callback(self, self, "_animate_fade_output"))
  end
end
