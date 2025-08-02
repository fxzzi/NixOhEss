{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.gaming.steam.enable = lib.mkEnableOption "steam";
  options.cfg.gaming.steam.shaderThreads = lib.mkOption {
    type = lib.types.int;
    default = 1;
    description = "Number of threads to use for shader processing in Steam.";
  };
  config = lib.mkIf config.cfg.gaming.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = lib.mkIf config.cfg.programs.proton-ge.enable [pkgs.proton-ge-bin];
    };
    hj = {
      files.".local/share/Steam/steam_dev.cfg".text = ''
        unShaderBackgroundProcessingThreads ${toString config.cfg.gaming.steam.shaderThreads}
      '';
    };
  };
}
