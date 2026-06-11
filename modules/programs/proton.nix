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
  };

  config = mkIf cfg.enable {
    boot.kernelModules = ["ntsync"];
    environment.sessionVariables = {
      PROTON_ENABLE_WAYLAND = mkIf cfg.nativeWayland 1;
      PROTON_USE_WOW64 = 1; # Some EAC games fail with this enabled
      # https://farnoy.dev/posts/linux-latency
      VKD3D_SWAPCHAIN_LATENCY_FRAMES = 1;
    };
  };
}
