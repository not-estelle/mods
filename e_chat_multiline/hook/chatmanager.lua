function ChatGui:_create_input_panel()
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
    color = Color.black:with_alpha(0.2)
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

  self._input_panel:rect({
    valign = "grow",
    name = "input_bg",
    layer = -1,
    color = Color.black:with_alpha(0.5),
    h = self._input_panel:h()
  })
  self._input_panel:child("input_bg"):set_w(self._input_panel:w() - w)
  self._input_panel:child("input_bg"):set_x(w)
  self._input_panel:stop()
  self._input_panel:animate(callback(self, self, "_animate_hide_input"))
end

function ChatGui:enter_text(o, s)
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

ChatGui.E_key_binds = {
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

function ChatGui:update_key_down(o, k)
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

function ChatGui:key_press(o, k)
  if self._skip_first then
    if k == Idstring("enter") then
      self._skip_first = false
    end

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

function ChatGui:update_caret()
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

  self._input_panel:child("input_bg"):set_color(Color.black:with_alpha(0.4))
end

function ChatGui:_layout_input_panel()
  self._input_panel:set_w(self._panel_width - self._input_panel:x())

  local say = self._input_panel:child("say")
  local input_text = self._input_panel:child("input_text")
  local _, _, _, h = input_text:text_rect()
  if h < 24 then h = 24 end

  input_text:set_left(say:right() + 4)
  input_text:set_w(self._input_panel:w() - input_text:left())
  input_text:set_h(h)
  self._input_panel:child("input_bg"):set_w(input_text:w())
  self._input_panel:child("input_bg"):set_x(input_text:x())

  local focus_indicator = self._input_panel:child("focus_indicator")

  focus_indicator:set_shape(input_text:shape())
  self._input_panel:set_h(h)
  self._input_panel:set_y(self._input_panel:parent():h() - h)
  self._input_panel:set_x(self._panel:child("output_panel"):x())
end
