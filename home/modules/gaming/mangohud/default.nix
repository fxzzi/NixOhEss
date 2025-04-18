{
  config,
  lib,
  ...
}: {
  options.cfg.gaming.mangohud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable MangoHud and it's configurations.";
    };
    enableSessionWide = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable MangoHud for all Vulkan apps.";
    };
  };
  config = lib.mkIf config.cfg.gaming.mangohud.enable {
    programs.mangohud = {
      enable = true;
      inherit (config.cfg.gaming.mangohud) enableSessionWide;
      settings = {
        preset = "0,1";
        fps_limit = "167,0"; # few below refresh rate (vrr) or unlimited
        toggle_hud = "Shift_R+F12";
        toggle_hud_position = "Shift_R+F11";
        toggle_preset = "Shift_R+F10";
      };
    };
    # home-manager mangohud module doesn't support
    # setting presets. so, set them here
    xdg.configFile."MangoHud/presets.conf".text = ''
      [preset 0]
      fps_only
      background_alpha=0

      hud_no_margin
      font_size=20

      [preset 1]
      background_alpha=0.3
      hud_no_margin
      gpu_text=GPU
      gpu_stats
      gpu_core_clock
      gpu_mem_clock
      gpu_temp
      gpu_power
      vram
      fps
      frame_timing
      cpu_text=CPU
      cpu_stats
      cpu_mhz
      cpu_temp
      cpu_power
      ram
      present_mode
    '';
  };
}
