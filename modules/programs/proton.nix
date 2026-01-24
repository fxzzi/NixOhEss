{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.proton-ge;
in {
  options.cfg.programs.proton-ge = {
    enable = mkEnableOption "proton-ge";
    nativeWayland = mkEnableOption "Wayland native proton";
    ntsync = mkEnableOption "ntsync support";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = mkIf cfg.ntsync [
      "ntsync"
    ];
    services.udev.extraRules = mkIf cfg.ntsync ''
      KERNEL=="ntsync", MODE="0644"
    '';

    environment.sessionVariables = {
      "PROTON_ENABLE_WAYLAND" = mkIf cfg.nativeWayland 1;
      # Without this, games won't detect a controller after they've launched
      # They'll only detect if the controller was connected before launching
      "PROTON_USE_SDL" = mkIf cfg.nativeWayland 1;
      # "WAYLANDDRV_PRIMARY_MONITOR" = mkIf cfg.nativeWayland config.cfg.programs.hyprland.defaultMonitor;
      "PROTON_USE_WOW64" = "1"; # pretty stable so should be fine to always enable
    };
  };
}
