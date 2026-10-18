{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionalAttrs;
  cfg = config.cfg.programs.steam;
in
{
  options.cfg.programs.steam = {
    enable = mkEnableOption "steam";
  };
  imports = [ "${inputs.nix-gaming}/modules/platformOptimizations.nix" ];
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      platformOptimizations.enable = true;
      package = pkgs.steam.override {
        extraEnv =
          optionalAttrs (!config.cfg.core.networkmanager.enable) {
            # When not using NetworkManager, steam startup is delayed for some reason. Setting this
            # envvar to a blank string works around it for now.
            # see: <https://github.com/ValveSoftware/steam-for-linux/issues/9966#issuecomment-4061620051>
            DBUS_SYSTEM_BUS_ADDRESS = "";
          }
          // optionalAttrs config.cfg.programs.obs-studio.enable {
            OBS_VKCAPTURE = "1";
          }
          // optionalAttrs config.cfg.programs.mangohud.enable {
            MANGOHUD = "1";
          };
      };
      extraCompatPackages = mkIf config.cfg.programs.proton-ge.enable [ pkgs.proton-ge-bin ];

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
