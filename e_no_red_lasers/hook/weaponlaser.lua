local original_set_color = WeaponLaser.set_color
function WeaponLaser:set_color(color)
  if not color then return end
  local hue, sat, val = rgb_to_hsv(color.r, color.g, color.b)
  if (hue <= 20 or hue >= 320) and sat >= 0.25 then
    color = Color(0.15, 0.5, 1, 0)
  end
  original_set_color(self, color)
end
