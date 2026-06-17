{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.hardware.evoctl;
  evoPkg = inputs.evoctl-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  options.cfg.hardware.evoctl.enable = mkEnableOption "evoctl";
  imports = [
    inputs.evoctl-nix.nixosModules.default
  ];
  config = mkIf cfg.enable {
    hardware.audient-evo = {
      enable = true;
      autostart = true;
    };
    environment.systemPackages = [evoPkg];
    systemd.services.mute-audient-evo = {
      unitConfig.description = "Mute Audient EVO Devices on Shutdown";
      serviceConfig = {
        Type = "oneshot";
        ExecStop = "${getExe evoPkg} set mute 1 -t output";
        RemainAfterExit = true;
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
