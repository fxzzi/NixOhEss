{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: let
  nixpkgs-sgdboop = inputs.nixpkgs-sgdboop.legacyPackages.${pkgs.system};
  nix-gaming = inputs.nix-gaming.packages.${pkgs.system};
  gpuType =
    if osConfig.cfg.gpu.nvidia.enable
    then "nvidia"
    else if osConfig.cfg.gpu.amdgpu.enable
    then "amd"
    else "full"; # Fallback in case neither is enabled
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
        (gamescope.overrideAttrs (_: {
          # NOTE: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
          NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
        })))
      (lib.mkIf config.cfg.gaming.cemu.enable cemu)
      (lib.mkIf config.cfg.gaming.nvtop.enable nvtopPackages.${gpuType})
      (lib.mkIf config.cfg.gaming.sgdboop.enable nixpkgs-sgdboop.sgdboop)
      (lib.mkIf config.cfg.gaming.osu-lazer.enable nix-gaming.osu-lazer-bin)
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
