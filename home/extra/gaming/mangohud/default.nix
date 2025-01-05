{ ... }: {
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      preset = "0,1";
      fps_limit = 170;
      vsync = 1;
      gl_vsync = 0;
      toggle_hud = "Shift_R+F12";
      toggle_hud_position = "Shift_R+F11";
      toggle_preset = "Shift_R+F10";
    };
  };
  # home-manager mangohud module doesn't support
  # setting presets. so, set them here
  home.file.".config/MangoHud/presets.conf".text =
    "	[preset 0]\n	fps_only\n	background_alpha=0\n\n	hud_no_margin\n	font_size=20\n\n	[preset 1]\n	background_alpha=0.3\n	hud_no_margin\n	gpu_text=GPU\n	gpu_stats\n	gpu_core_clock\n	gpu_mem_clock\n	gpu_temp\n	gpu_power\n	vram\n	fps\n	frame_timing\n	cpu_text=CPU\n	cpu_stats\n	cpu_mhz\n	cpu_temp\n	cpu_power\n	ram\n	present_mode\n";
}
