{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionalAttrs;
  cfg = config.cfg.programs.steam;
in {
  options.cfg.programs.steam = {
    enable = mkEnableOption "steam";
  };
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = optionalAttrs config.cfg.programs.obs-studio.enable 1;
          # allow using the nvidia reflex layer.
          # according to nvidia it can cause issues in apps which
          # don't even use reflex, so enable it in here only for lutris
          DXVK_NVAPI_VKREFLEX = optionalAttrs config.cfg.hardware.nvidia.enable 1;
          # https://github.com/Korthos-Software/low_latency_layer
          # LOW_LATENCY_LAYER = optionalAttrs config.cfg.hardware.amdgpu.enable 1;
          MANGOHUD = optionalAttrs config.cfg.programs.mangohud.enable 1;
        };
      };
      extraCompatPackages = mkIf config.cfg.programs.proton-ge.enable [pkgs.proton-ge-bin];

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
