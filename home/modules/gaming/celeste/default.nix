{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  nixpkgs-olympus = inputs.nixpkgs-olympus.legacyPackages.${pkgs.system};
in {
  options.cfg.gaming.celeste = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "adds a script to path to run Celeste with steam-run";
    };
    modding.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable olympus";
    };
  };
  config = lib.mkIf config.cfg.gaming.celeste.enable {
    home.packages = with pkgs; [
      steam-run
      (lib.mkIf config.cfg.gaming.celeste.modding.enable nixpkgs-olympus.olympus)
    ];
  };
}
