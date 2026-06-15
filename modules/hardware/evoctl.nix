{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.evoctl;
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
    environment.systemPackages = [
      inputs.evoctl-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    users.users.${config.cfg.core.username}.extraGroups = [
      "dialout"
    ];
  };
}
