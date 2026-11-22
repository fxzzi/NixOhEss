local bin = nix.bin

local function bind(keys, action, opts)
  hl.bind(table.concat(keys, " + "), action, opts)
end

local mainMod = "SUPER"

-- screenshot script
bind({ "Print" }, hl.dsp.exec_raw(bin.screenshot .. " --monitor"))
bind({ "SHIFT", "Print" }, hl.dsp.exec_raw(bin.screenshot .. " --selection"))
bind({ mainMod, "SHIFT", "S" }, hl.dsp.exec_raw(bin.screenshot .. " --selection"))
bind({ mainMod, "Print" }, hl.dsp.exec_raw(bin.screenshot .. " --active"))

-- annotate the image in clipboard
bind({ mainMod, "A" }, hl.dsp.exec_raw("wl-paste | " .. bin.swappy .. " -f -"))

-- binds for apps
bind({ mainMod, "F" }, hl.dsp.exec_raw("thunar"))
bind({ mainMod, "T" }, hl.dsp.exec_raw("xdg-terminal-exec"))
bind({ mainMod, "B" }, hl.dsp.exec_raw("librewolf"))
bind({ mainMod, "SHIFT", "P" }, hl.dsp.exec_raw("librewolf --private-window"))
bind({ mainMod, "W" }, hl.dsp.exec_raw("Discord"))
bind({ mainMod, "D" }, hl.dsp.exec_raw("pkill fuzzel || fuzzel"))
bind({ mainMod, "SHIFT", "E" }, hl.dsp.exec_raw("ags -t power-menu"))
bind({ "CTRL", "SHIFT", "Escape" }, hl.dsp.exec_raw("xdg-terminal-exec btm"))
-- extra schtuff
bind({ mainMod, "N" }, hl.dsp.exec_raw(bin.sunset .. " 3000"))
bind({ mainMod, "R" }, hl.dsp.exec_raw(bin.randomWall))
bind(
  { mainMod, "SHIFT", "R" },
  hl.dsp.exec_raw("hyprctl reload && " .. bin.dunstify .. " 'Hyprland' 'Reloaded Successfully.'")
)
bind({ mainMod, "K" }, hl.dsp.exec_raw("hyprctl kill"))
bind({ mainMod, "J" }, hl.dsp.exec_raw("ags -t wall-picker"))
bind({ mainMod, "L" }, hl.dsp.exec_raw("loginctl lock-session"))
bind(
  { mainMod, "V" },
  hl.dsp.exec_raw(
    [[pkill fuzzel || (sel=$(cliphist list | fuzzel --width 75 --dmenu --with-nth 2 -p ' ') && [ -n "$sel" ] && printf '%s' "$sel" | cliphist decode | wl-copy)]]
  )
)

-- mpd media controls
bind({ "XF86AudioPrev" }, hl.dsp.exec_raw(bin.mpc .. " prev"))
bind({ "XF86AudioPlay" }, hl.dsp.exec_raw(bin.mpc .. " toggle"))
bind({ "XF86AudioNext" }, hl.dsp.exec_raw(bin.mpc .. " next"))

-- shortcuts for OBS
bind({ "CTRL", "SHIFT", "grave" }, hl.dsp.global("com.obsproject.Studio:_toggle_recording"))
bind({ "CTRL", "grave" }, hl.dsp.global("com.obsproject.Studio:ReplayBuffer.Save"))

-- window management
bind({ mainMod, "Q" }, hl.dsp.window.close())
bind({ mainMod, "Space" }, hl.dsp.window.fullscreen(1))
bind({ mainMod, "Tab" }, hl.dsp.window.float({ action = "toggle" }))
bind({ mainMod, "P" }, hl.dsp.window.pseudo())
bind({ mainMod, "S" }, hl.dsp.layout("togglesplit"))

-- focus
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  bind({ mainMod, dir }, hl.dsp.focus({ direction = dir }))
end

-- move
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  bind({ mainMod, "SHIFT", dir }, hl.dsp.window.move({ direction = dir }))
end

for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  bind({ mainMod, tostring(key) }, hl.dsp.focus({ workspace = i }))
  bind({ mainMod, "SHIFT", tostring(key) }, hl.dsp.window.move({ workspace = i }))
end

-- navigate through workspaces on mouse
bind({ mainMod, "mouse_down" }, hl.dsp.focus({ workspace = "e+1" }))
bind({ mainMod, "mouse_up" }, hl.dsp.focus({ workspace = "e-1" }))

-- resize
for _, resize in ipairs({
  { "left", -10, 0 },
  { "right", 10, 0 },
  { "up", 0, -10 },
  { "down", 0, 10 },
}) do
  bind(
    { mainMod, "CTRL", resize[1] },
    hl.dsp.window.resize({ x = resize[2], y = resize[3], relative = true }),
    { repeating = true }
  )
end

-- audio binds
for _, a in ipairs({
  { { "XF86AudioRaiseVolume" }, "vol up 5" },
  { { "SHIFT", "XF86AudioRaiseVolume" }, "vol up 1" },

  { { "XF86AudioLowerVolume" }, "vol down 5" },
  { { "SHIFT", "XF86AudioLowerVolume" }, "vol down 1" },

  { { "XF86AudioMute" }, "vol toggle" },

  { { "XF86AudioMicMute" }, "mic toggle" },
  { { mainMod, "SHIFT", "M" }, "mic toggle" },
}) do
  bind(a[1], hl.dsp.exec_raw(bin.audio .. " " .. a[2]), { locked = true, repeating = true })
end

-- brightness binds
for _, b in ipairs({
  { "XF86MonBrightnessUp", "up" },
  { "XF86MonBrightnessDown", "down" },
}) do
  bind({ b[1] }, hl.dsp.exec_raw(bin.brightness .. " " .. b[2] .. " 5"), { locked = true, repeating = true })
end

-- mouse binds
bind({ mainMod, "mouse:272" }, hl.dsp.window.drag(), { mouse = true }) -- left click
bind({ mainMod, "mouse:273" }, hl.dsp.window.resize(), { mouse = true }) -- right click
-- these binds allow you to easily drag and resize on touchpad
if nix.isLaptop then
  bind({ mainMod, "CONTROL_L" }, hl.dsp.window.drag(), { mouse = true })
  bind({ mainMod, "ALT_L" }, hl.dsp.window.resize(), { mouse = true })
end
