hl.device({
  -- thinkpad l14 keyboard
  name = "at-translated-set-2-keyboard",
  kb_layout = "gb",
})

hl.device({
  -- thinkpad l14 touchpad
  name = "elan0680:00-04f3:320a-touchpad",
  -- https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
  accel_profile = "custom",
  scroll_points = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139",
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})
