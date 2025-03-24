{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  nixpkgs-sgdboop = inputs.nixpkgs-sgdboop.legacyPackages.${pkgs.system};
in {
  options.cfg.gaming = {
    proton-ge.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable proton-ge for Lutris / Heroic if enabled";
    };
    gamescope.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables gamescope.";
    };
    cemu.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the cemu emulator.";
    };
    nvtop.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the nvtop gpu monitor";
    };
    sgdboop.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables steamgriddb sgdboop.";
    };
    osu-lazer.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables osu-lazer.";
    };
  };

  config = {
    home.packages = with pkgs; [
      (lib.mkIf config.cfg.gaming.gamescope.enable
        (gamescope.overrideAttrs {
          # NOTE: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
          NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
        }))
      (lib.mkIf config.cfg.gaming.cemu.enable cemu)
      (lib.mkIf config.cfg.gaming.sgdboop.enable nixpkgs-sgdboop.sgdboop)
      (lib.mkIf config.cfg.gaming.osu-lazer.enable osu-lazer-bin)
    ];
  };
  imports = [
    ./mangohud
    ./prismlauncher
    ./lutris
    ./heroic
    ./celeste
  ];
}
