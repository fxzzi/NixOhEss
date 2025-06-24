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
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    hj = {
      files.".local/share/Steam/steam_dev.cfg".text = ''
        unShaderBackgroundProcessingThreads ${toString config.cfg.gaming.steam.shaderThreads}
      '';
    };
  };
}
