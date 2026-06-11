{
  lib,
  config,
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
    hardware.audient-evo.enable = true;
  };
}
