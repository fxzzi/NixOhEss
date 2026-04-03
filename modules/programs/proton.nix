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
    environment.sessionVariables = {
      "PROTON_ENABLE_WAYLAND" = mkIf cfg.nativeWayland 1;
      "PROTON_USE_WOW64" = 1; # pretty stable so should be fine to always enable
    };
  };
}
