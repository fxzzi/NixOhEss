-- emulators and similar apps that should be tagged as games, but not forced fullscreen
for _, match in ipairs({
  { class = "info.cemu.Cemu" },
  { class = "org.eden_emu.eden" },
  { class = "dev.eden_emu.eden" },
  { class = "dolphin-emu" },
  { initial_title = "PCSX2 v.*" },
}) do
  hl.window_rule({ match = match, tag = "+game" })
end

-- wine/proton/native titles that should launch fullscreen
for _, match in ipairs({
  { xdg_tag = "proton-game" }, -- proton w/ wine-wayland sets this
  { class = "steam_app_.*" }, -- umu / proton xwayland set this
  { class = "com.libretro.RetroArch" },
  { class = ".*_linux" }, -- 32-bit source
  { class = ".*_linux64" }, -- 64-bit source
  { class = ".*.x86_64" }, -- native sdl games
  { class = "momentum" }, -- momentum mod
  { class = "cs2" },
  { class = "org-prismlauncher-EntryPoint" }, -- legacy mc
  { class = "minecraft" }, -- gregtech:nh ?
  { initial_title = "Minecraft\\* .*" }, -- mc up to v26.1
  { initial_title = "Minecraft .*" }, -- v26.2-26.3 mc
  { class = "com.mojang.minecraft" }, -- v26.3+
  { class = "osu!" },
  { class = "gamescope" },
  { class = "Celeste" },
  { class = "sm64coopdx" },
  { class = "UnleashedRecomp" },
  { class = "sober" },
  { class = "Cordial" },
  { class = "waywall" },
  { class = "love", title = "Freesync test" },
  { class = "dotnet", initial_title = "Terraria: .*" },
  { initial_title = "Clustertruck" },
  { class = "dev.magicbean.Longshot" },
}) do
  hl.window_rule({ match = match, tag = "+game", fullscreen = true })
  hl.window_rule({ match = match, tag = "+confine" })
end

-- apply behavior by tag
hl.window_rule({
  match = { tag = "game" },
  -- setting content type allows ds to apply
  content = "game",
  -- pause hypridle in fullscreen games
  idle_inhibit = "fullscreen",
  -- allow tearing
  immediate = true,
  -- disable tonemapping. configure luminances and stuff
  -- in game instead.
  tonemap = "off",
})

-- confine cursor to the monitor when a game is in fullscreen.
if nix.monitors.secondary then
  hl.window_rule({ match = { tag = "confine", fullscreen = true }, confine_pointer = true })
end
