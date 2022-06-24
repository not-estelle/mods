function TimeSpeedEffectTweakData:_init_base_effects()
  self.mask_on = {
    sustain = 0,
    timer = "pausable",
    speed = 1,
    fade_out = 0,
    fade_in = 0,
    fade_in_delay = 0
  }
  self.mask_on_player = {
    speed = 1,
    affect_timer = "player",
    fade_in_delay = self.mask_on.fade_in_delay,
    fade_in = self.mask_on.fade_in,
    sustain = self.mask_on.sustain,
    fade_out = self.mask_on.fade_out,
    timer = self.mask_on.timer
  }
  self.downed = {
    sustain = 0,
    timer = "pausable",
    speed = 1,
    fade_in = 0,
    fade_out = 0
  }
  self.downed_player = {
    affect_timer = "player",
    speed = self.downed.speed,
    fade_in = self.downed.fade_in,
    sustain = self.downed.sustain,
    fade_out = self.downed.fade_out,
    timer = self.downed.timer
  }
end

function TimeSpeedEffectTweakData:_init_mission_effects()
  self.mission_effects = {
    quickdraw = {
      sustain = 0,
      timer = "pausable",
      speed = 1,
      fade_out = 0,
      fade_in = 0,
      sync = true,
      fade_in_delay = 0
    }
  }
  self.mission_effects.quickdraw_player = {
    timer = "pausable",
    speed = 1,
    affect_timer = "player",
    sync = true,
    fade_in_delay = self.mission_effects.quickdraw.fade_in_delay,
    fade_in = self.mission_effects.quickdraw.fade_in,
    sustain = self.mission_effects.quickdraw.sustain,
    fade_out = self.mission_effects.quickdraw.fade_out
  }
end