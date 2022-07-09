HUDChat.max_lines = 12 -- vanilla is 10

local original_init = HUDChat.init
function HUDChat:init(ws, hud)
  original_init(self, ws, hud)

  local output_panel = self._panel:child("output_panel")

  local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar_arrow")
  local scroll_up_indicator_arrow = output_panel:bitmap({
    name = "scroll_up_indicator_arrow",
    layer = 2,
    texture = texture,
    texture_rect = rect,
    color = Color.white,
  })
  local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar_arrow")
  local scroll_down_indicator_arrow = output_panel:bitmap({
    name = "scroll_down_indicator_arrow",
    layer = 2,
    rotation = 180,
    texture = texture,
    texture_rect = rect,
    color = Color.white,
  })
  self._scroll_width = scroll_down_indicator_arrow:w() + 2

  local scroll_panel = output_panel:panel({
    name = "scroll_panel",
    x = self._scroll_width,
    h = 10,
    w = self._output_width,
  })
  self._scroll_indicator_box_class = BoxGuiObject:new(output_panel, {
    sides = {
      0,
      0,
      0,
      0,
    }
  })
  local bar_h = scroll_down_indicator_arrow:top() - scroll_up_indicator_arrow:bottom()
  local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar")
  local scroll_bar = output_panel:panel({
    w = 15,
    name = "scroll_bar",
    layer = 2,
    h = bar_h,
  })
  local scroll_bar_box_panel = scroll_bar:panel({
    name = "scroll_bar_box_panel",
    halign = "scale",
    w = 4,
    x = 5,
    valign = "scale",
  })
  self._scroll_bar_box_class = BoxGuiObject:new(scroll_bar_box_panel, {
    sides = {
      2,
      2,
      0,
      0,
    },
  })
  local scroll_up_indicator_shade = output_panel:bitmap({
    texture = "guis/textures/headershadow",
    name = "scroll_up_indicator_shade",
    visible = false,
    rotation = 180,
    layer = 2,
    color = Color.white,
    w = output_panel:w() - self._scroll_width,
    x = self._scroll_width,
  })
  local scroll_down_indicator_shade = output_panel:bitmap({
    texture = "guis/textures/headershadow",
    name = "scroll_down_indicator_shade",
    visible = false,
    layer = 2,
    color = Color.white,
    w = output_panel:w() - self._scroll_width,
    x = self._scroll_width,
  })

  self._input_panel:set_x(self._scroll_width)

  self:_layout_input_panel()
  self:_layout_output_panel(true)
end

function HUDChat:_create_input_panel()
  self._input_panel = self._panel:panel({
    name = "input_panel",
    h = 24,
    alpha = 0,
    x = 0,
    layer = 1,
    w = self._panel_width
  })

  self._input_panel:rect({
    name = "focus_indicator",
    layer = 0,
    visible = false,
    color = Color.white:with_alpha(0.2)
  })

  local say = self._input_panel:text({
    y = 0,
    name = "say",
    vertical = "center",
    hvertical = "center",
    align = "left",
    blend_mode = "normal",
    halign = "left",
    x = 0,
    layer = 1,
    text = utf8.to_upper(managers.localization:text("debug_chat_say")),
    font = tweak_data.menu.pd2_small_font,
    font_size = tweak_data.menu.pd2_small_font_size,
    color = Color.white
  })
  local _, _, w, h = say:text_rect()

  say:set_size(w, self._input_panel:h())

  local input_text = self._input_panel:text({
    y = 0,
    name = "input_text",
    vertical = "center",
    wrap = true,
    align = "left",
    blend_mode = "normal",
    hvertical = "center",
    text = "",
    word_wrap = true,
    halign = "left",
    x = 0,
    layer = 1,
    font = tweak_data.menu.pd2_small_font,
    font_size = tweak_data.menu.pd2_small_font_size,
    color = Color.white
  })
  local caret = self._input_panel:rect({
    name = "caret",
    h = 0,
    y = 0,
    w = 0,
    x = 0,
    layer = 2,
    color = Color(0.05, 1, 1, 1)
  })

  if _G.IS_VR then
    say:set_visible(false)
    caret:set_visible(false)
  end

  self._input_panel:gradient({
    blend_mode = "sub",
    name = "input_bg",
    valign = "grow",
    layer = -1,
    gradient_points = {
      0,
      Color.white:with_alpha(0),
      0.2,
      Color.white:with_alpha(0.25),
      1,
      Color.white:with_alpha(0)
    },
    h = self._input_panel:h()
  })
end

function HUDChat:_layout_input_panel()
  if not self._scroll_width then return end

  self._input_panel:set_w(self._panel_width)

  local say = self._input_panel:child("say")
  local input_text = self._input_panel:child("input_text")
  local _, _, _, h = input_text:text_rect()
  if h < 24 then h = 24 end

  input_text:set_left(say:right() + 4)
  input_text:set_w(self._input_panel:w() - input_text:left() - self._scroll_width)
  input_text:set_h(h)

  local focus_indicator = self._input_panel:child("focus_indicator")

  focus_indicator:set_shape(input_text:shape())
  self._input_panel:set_h(h)
  self._input_panel:set_y(self._input_panel:parent():h() - h)
end

function HUDChat:_layout_output_panel(force_update_scroll_indicators, scroll_at_bottom)
  local output_panel = self._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  if not scroll_panel then return end

  scroll_panel:set_w(self._output_width - self._scroll_width)
  output_panel:set_w(self._output_width)

  local line_height = HUDChat.line_height
  local max_lines = HUDChat.max_lines
  local lines = 0

  for i = #self._lines, 1, -1 do
    local line = self._lines[i][1]
    local icon = self._lines[i][2]

    line:set_w(scroll_panel:w() - line:left())

    local _, _, w, h = line:text_rect()

    line:set_h(h)

    lines = lines + line:number_of_lines()
  end

  scroll_at_bottom = scroll_at_bottom or scroll_panel:bottom() == output_panel:h()

  output_panel:set_h(math.round(line_height * math.min(max_lines, lines)))
  scroll_panel:set_h(math.round(line_height * lines))

  local y = 0

  for i = #self._lines, 1, -1 do
    local line = self._lines[i][1]
    local icon = self._lines[i][2]
    local _, _, w, h = line:text_rect()

    line:set_bottom(scroll_panel:h() - y)

    if icon then
      icon:set_left(icon:left())
      icon:set_top(line:top() + 1)
      line:set_left(icon:right())
    else
      line:set_left(line:left())
    end

    y = y + line_height * line:number_of_lines()
  end

  output_panel:set_bottom(math.round(self._input_panel:top()))

  if lines <= max_lines or scroll_at_bottom then
    scroll_panel:set_bottom(output_panel:h())
  end

  self:set_scroll_indicators(force_update_scroll_indicators)
end

function HUDChat:set_scroll_indicators(force_update_scroll_indicators)
  local output_panel = self._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  local scroll_up_indicator_shade = output_panel:child("scroll_up_indicator_shade")
  local scroll_up_indicator_arrow = output_panel:child("scroll_up_indicator_arrow")
  local scroll_down_indicator_shade = output_panel:child("scroll_down_indicator_shade")
  local scroll_down_indicator_arrow = output_panel:child("scroll_down_indicator_arrow")
  local scroll_bar = output_panel:child("scroll_bar")

  scroll_up_indicator_shade:set_top(0)
  scroll_down_indicator_shade:set_bottom(output_panel:h())
  scroll_up_indicator_arrow:set_lefttop(0, 2)
  scroll_down_indicator_arrow:set_leftbottom(0, output_panel:h() - 2)

  local bar_h = scroll_down_indicator_arrow:top() - scroll_up_indicator_arrow:bottom()

  if scroll_panel:h() ~= 0 then
    local old_h = scroll_bar:h()

    scroll_bar:set_h(bar_h * output_panel:h() / scroll_panel:h())

    if old_h ~= scroll_bar:h() then
      self._scroll_bar_box_class:create_sides(scroll_bar:child("scroll_bar_box_panel"), {
        sides = {
          2,
          2,
          0,
          0
        },
      })
    end
  end

  local sh = scroll_panel:h() ~= 0 and scroll_panel:h() or 1

  scroll_bar:set_y(scroll_up_indicator_arrow:bottom() - scroll_panel:y() * (output_panel:h() - scroll_up_indicator_arrow:h() * 2) / sh)
  scroll_bar:set_center_x(scroll_up_indicator_arrow:center_x())

  local visible = output_panel:h() < scroll_panel:h()
  local scroll_up_visible = visible and scroll_panel:top() < 0
  local scroll_dn_visible = visible and output_panel:h() < scroll_panel:bottom()

  self:_layout_input_panel()
  scroll_bar:set_visible(visible)

  local update_scroll_indicator_box = force_update_scroll_indicators or false

  if scroll_up_indicator_arrow:visible() ~= scroll_up_visible then
    scroll_up_indicator_shade:set_visible(false)
    scroll_up_indicator_arrow:set_visible(scroll_up_visible)

    update_scroll_indicator_box = true
  end

  if scroll_down_indicator_arrow:visible() ~= scroll_dn_visible then
    scroll_down_indicator_shade:set_visible(false)
    scroll_down_indicator_arrow:set_visible(scroll_dn_visible)

    update_scroll_indicator_box = true
  end

  if update_scroll_indicator_box then
    self._scroll_indicator_box_class:create_sides(output_panel, {
      sides = {
        0,
        0,
        scroll_up_visible and 2 or 0,
        scroll_dn_visible and 2 or 0
      },
      w = scroll_panel:w(),
    })
    self._scroll_indicator_box_class._panel:set_x(self._scroll_width)
  end
end

local original_enter_key_callback = HUDChat.enter_key_callback
function HUDChat:enter_key_callback()
  local text = self._input_panel:child("input_text")
  local message = text:text()

  if E.commands:process(message) then
    text:set_text("")
    text:set_selection(0, 0)
    managers.hud:set_chat_focus(false)
    return
  end

  original_enter_key_callback(self)
end

function HUDChat:receive_message(name, message, color, icon)
  local output_panel = self._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  local len = utf8.len(name) + 1
  local x = 0
  local icon_bitmap = nil

  if icon then
    local icon_texture, icon_texture_rect = tweak_data.hud_icons:get_icon_data(icon)
    icon_bitmap = scroll_panel:bitmap({
      y = 1,
      texture = icon_texture,
      texture_rect = icon_texture_rect,
      color = color
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
    text = name .. ": " .. message,
    font = tweak_data.menu.pd2_small_font,
    font_size = tweak_data.menu.pd2_small_font_size,
    x = x,
    color = color
  })
  local total_len = utf8.len(line:text())

  line:set_range_color(0, len, color)
  line:set_range_color(len, total_len, Color.white)

  local _, _, w, h = line:text_rect()

  line:set_h(h)
  table.insert(self._lines, {
    line,
    icon_bitmap
  })
  line:set_kern(line:kern())

  self:_layout_output_panel(false, true)

  if not self._focus then
    local output_panel = self._panel:child("output_panel")

    output_panel:stop()
    output_panel:animate(callback(self, self, "_animate_show_component"), output_panel:alpha())
    output_panel:animate(callback(self, self, "_animate_fade_output"))
  end
end

function HUDChat:E_receive_message(rich_string, icon)
  local output_panel = self._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")

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
  self:_layout_output_panel(false, true)

  if not self._focus then
    local output_panel = self._panel:child("output_panel")

    output_panel:stop()
    output_panel:animate(callback(self, self, "_animate_show_component"), output_panel:alpha())
    output_panel:animate(callback(self, self, "_animate_fade_output"))
  end
end

function HUDChat:update_caret()
  local text = self._input_panel:child("input_text")
  local caret = self._input_panel:child("caret")
  local s, e = text:selection()
  local x, y, w, h = text:selection_rect()

  if s == 0 and e == 0 then
    if text:align() == "center" then
      x = text:world_x() + text:w() / 2
    else
      x = text:world_x()
    end

    y = text:world_y()
  end

  h = 24

  if w < 3 then
    w = 3
  end

  if not self._focus then
    w = 0
    h = 0
  end

  caret:set_world_shape(x, y + 2, w, h - 4)
  self:set_blinking(s == e and self._focus)

  local mid = x / self._input_panel:child("input_bg"):w()

  self._input_panel:child("input_bg"):set_gradient_points({
    0,
    Color.white:with_alpha(0),
    mid,
    Color.white:with_alpha(0.25),
    1,
    Color.white:with_alpha(0)
  })
end

function HUDChat:enter_text(o, s)
  if managers.hud and managers.hud:showing_stats_screen() then
    return
  end

  if self._skip_first then
    self._skip_first = false

    return
  end

  local text = self._input_panel:child("input_text")

  if type(self._typing_callback) ~= "number" then
    self._typing_callback()
  end

  text:replace_text(s)

  self:_layout_input_panel()
  self:_layout_output_panel()
  self:update_caret()
end

Hooks:PreHook(HUDChat, "_on_focus", "E.base HUDChat._on_focus", function(self)
  if self._focus then return end

  managers.mouse_pointer:use_mouse({
    -- mouse_move = callback(self, self, "mouse_moved"),
    mouse_press = callback(self, self, "E_mouse_press"),
    -- mouse_release = callback(self, self, "mouse_released"),
    -- mouse_click = callback(self, self, "mouse_clicked"),
    -- mouse_double_click = callback(self, self, "mouse_double_click"),
    id = "E_base chat",
  }, nil)
end)
Hooks:PreHook(HUDChat, "_loose_focus", "E.base HUDChat._loose_focus", function(self)
  if not self._focus then return end

  managers.mouse_pointer:remove_mouse("E_base chat")
  -- self._one_scroll_up_delay = nil
  -- self._one_scroll_dn_delay = nil
end)

function HUDChat:E_mouse_press(o, k, x, y)
  if k == Idstring("mouse wheel up") then
    if self:mouse_wheel_up() then
      self:set_scroll_indicators()
      return true
    end
  elseif k == Idstring("mouse wheel down") then
    if self:mouse_wheel_down() then
      self:set_scroll_indicators()
      return true
    end
  end
end

function HUDChat:mouse_wheel_up(x, y)
  -- if self._one_scroll_up_delay then
  --   self._one_scroll_up_delay = nil
  --   return true
  -- end

  return self:scroll_up()
end

function HUDChat:mouse_wheel_down(x, y)
  -- if self._one_scroll_dn_delay then
  --   self._one_scroll_dn_delay = nil
  --   return true
  -- end

  return self:scroll_down()
end

function HUDChat:scroll_up()
  local output_panel = self._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")

  if output_panel:h() < scroll_panel:h() then
    if scroll_panel:top() == 0 then
      self._one_scroll_dn_delay = true
    end

    scroll_panel:set_top(math.min(0, scroll_panel:top() + HUDChat.line_height))

    return true
  end
end

function HUDChat:scroll_down()
  local output_panel = self._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")

  if output_panel:h() < scroll_panel:h() then
    if scroll_panel:bottom() == output_panel:h() then
      self._one_scroll_up_delay = true
    end

    scroll_panel:set_bottom(math.max(scroll_panel:bottom() - HUDChat.line_height, output_panel:h()))

    return true
  end
end

HUDChat.E_key_binds = {
  [Idstring("backspace"):key()] = function(self, text)
    local s, e = text:selection()
    if s == e and s > 0 then
      text:set_selection(s - 1, e)
    end
    text:replace_text("")
  end,
  [Idstring("delete"):key()] = function(self, text)
    local s, e = text:selection()
    local n = utf8.len(text:text())
    if s == e and s < n then
      text:set_selection(s, e + 1)
    end
    text:replace_text("")
  end,
  [Idstring("insert"):key()] = function(self, text)
    local clipboard = Application:get_clipboard() or ""
    text:replace_text(clipboard)
  end,
  [Idstring("left"):key()] = function(self, text)
    local s, e = text:selection()
    if s < e then
      text:set_selection(s, s)
    elseif s > 0 then
      text:set_selection(s - 1, s - 1)
    end
  end,
  [Idstring("right"):key()] = function(self, text)
    local s, e = text:selection()
    local n = utf8.len(text:text())
    if s < e then
      text:set_selection(e, e)
    elseif s < n then
      text:set_selection(s + 1, s + 1)
    end
  end,
  [Idstring("end"):key()] = function(self, text)
    local n = utf8.len(text:text())
    text:set_selection(n, n)
  end,
  [Idstring("home"):key()] = function(self, text)
    text:set_selection(0, 0)
  end,
  [Idstring("enter"):key()] = function(self, text)
    if type(self._enter_callback) == "number" then return end
    self._enter_callback()
  end,
  [Idstring("esc"):key()] = function(self, text)
    if type(self._esc_callback) == "number" then return end
    text:set_text("")
    text:set_selection(0, 0)
    self._esc_callback()
  end,
}

function HUDChat:key_press(o, k)
  if self._skip_first then
    self._skip_first = false
    return
  end

  if not self._enter_text_set then
    self._input_panel:enter_text(callback(self, self, "enter_text"))

    self._enter_text_set = true
  end

  local text = self._input_panel:child("input_text")
  self._key_pressed = k

  text:stop()
  text:animate(callback(self, self, "update_key_down"), k)

  local bind = self.E_key_binds[k:key()]
  if bind then
    bind(self, text, k)
  end

  self:_layout_input_panel()
  self:_layout_output_panel()
  self:update_caret()
end

function HUDChat:update_key_down(o, k)
  wait(0.6)

  local text = self._input_panel:child("input_text")

  while self._key_pressed == k do
    local bind = self.E_key_binds[k:key()]
    if bind then
      bind(self, text, k)
    else
      self._key_pressed = false
    end

    self:_layout_input_panel()
    self:_layout_output_panel()
    self:update_caret()
    wait(0.03)
  end
end

function HUDChat:set_output_alpha(alpha)
  self._panel:child("output_panel"):set_alpha(alpha)
end
