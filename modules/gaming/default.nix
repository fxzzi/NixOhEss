{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}: let
  nixpkgs-sgdboop = inputs.nixpkgs-sgdboop.legacyPackages.${pkgs.system};
in {
  options.cfg.gaming = {
    proton-ge.enable = lib.mkEnableOption "proton-ge";
    gamescope.enable = lib.mkEnableOption "gamescope";
    cemu.enable = lib.mkEnableOption "cemu";
    nvtop.enable = lib.mkEnableOption "nvtop";
    sgdboop.enable = lib.mkEnableOption "sgdboop";
    osu-lazer.enable = lib.mkEnableOption "osu-lazer";
  };

  config = {
    users.users.${user} = {
      extraGroups = [
        # some games n stuff need these
        # e.g. ClickBetweenFrames mod on GD
        "video"
        "input"
      ];
    };
    hj = {
      packages = with pkgs; [
        (
          lib.mkIf config.cfg.gaming.gamescope.enable
          # (gamescope.overrideAttrs {
          #   # NOTE: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
          #   NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
          # })
          gamescope
        )
        (lib.mkIf config.cfg.gaming.cemu.enable cemu)
        (lib.mkIf config.cfg.gaming.sgdboop.enable nixpkgs-sgdboop.sgdboop)
        (lib.mkIf config.cfg.gaming.osu-lazer.enable osu-lazer-bin)
      ];
    };
  };
  imports = [
    ./gamemode.nix
    ./steam.nix

    ./celeste
    ./creamlinux
    ./heroic
    ./lutris
    ./mangohud
    ./prismlauncher
  ];
}
