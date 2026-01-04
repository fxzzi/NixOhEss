{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.cfg.programs.steam;
in {
  options.cfg.programs.steam = {
    enable = mkEnableOption "steam";
    shaderThreads = mkOption {
      type = types.int;
      default = 1;
      description = "Number of threads to use for shader processing in Steam.";
    };
  };
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        # maybe fix steam input in winewayland
        extraArgs = "-steamos3";
      };
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = mkIf config.cfg.programs.proton-ge.enable [pkgs.proton-ge-bin];
    };
    hj = {
      files.".local/share/Steam/steam_dev.cfg".text = ''
        unShaderBackgroundProcessingThreads ${toString cfg.shaderThreads}
      '';
    };
    hardware.steam-hardware.enable = true;
  };
}
