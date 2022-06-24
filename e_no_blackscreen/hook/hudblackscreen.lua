function HUDBlackScreen:fade_out_mid_text()
  self._blackscreen_panel:child("mid_text"):set_alpha(0)

  local job_panel = self._blackscreen_panel:child("job_panel")
  if job_panel then
    job_panel:set_alpha(0)
  end

  self._blackscreen_panel:set_alpha(0)
end
function HUDBlackScreen:fade_in_mid_text()
  self._blackscreen_panel:child("mid_text"):set_alpha(1)

  local job_panel = self._blackscreen_panel:child("job_panel")
  if job_panel then
    job_panel:set_alpha(1)
  end

  self._blackscreen_panel:set_alpha(1)
end

-- Hooks:PostHook(HUDBlackScreen, "_animate_fade_out", "E_no_blackscreen_HUDBlackScreen__animate_fade_out", function(self)
--   local job_panel = self._blackscreen_panel:child("job_panel")

--   mid_text:set_alpha(0)

--   if job_panel then
--     job_panel:set_alpha(0)
--   end

--   self._blackscreen_panel:set_alpha(0)


-- end)

-- function HUDBlackScreen:_animate_fade_out(mid_text)
--   local job_panel = self._blackscreen_panel:child("job_panel")

--   mid_text:set_alpha(0)

--   if job_panel then
--     job_panel:set_alpha(0)
--   end

--   self._blackscreen_panel:set_alpha(0)
-- end
