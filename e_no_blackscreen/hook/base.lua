E:mod("no_blackscreen")

tweak_data.overlay_effects.fade_out_permanent = {
  blend_mode = "normal",
  fade_out = 0,
  play_paused = true,
  fade_in = 0,
  color = Color(1, 0, 0, 0),
  timer = TimerManager:main()
}

tweak_data.overlay_effects.level_fade_in = {
  blend_mode = "normal",
  sustain = 1,
  play_paused = true,
  fade_in = 0,
  fade_out = 0,
  color = Color(0, 0, 0, 0),
  timer = TimerManager:game()
}
