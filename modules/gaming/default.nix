{
  config,
  lib,
  pkgs,
  user,
  npins,
  inputs,
  ...
}: let
  cfg = config.cfg.gaming;
in {
  options.cfg.gaming = {
    proton-ge.enable = lib.mkEnableOption "proton-ge";
    gamescope.enable = lib.mkEnableOption "gamescope";
    cemu.enable = lib.mkEnableOption "cemu";
    nvtop.enable = lib.mkEnableOption "nvtop";
    sgdboop.enable = lib.mkEnableOption "sgdboop";
    osu-lazer.enable = lib.mkEnableOption "osu-lazer";
    vkbasalt.enable = lib.mkEnableOption "vkBasalt";
    yuzu.enable = lib.mkEnableOption "yuzu";
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
          lib.mkIf cfg.gamescope.enable
          (gamescope.overrideAttrs {
            # NOTE: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
            NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
          })
        )
        (lib.mkIf cfg.cemu.enable cemu)
        (lib.mkIf cfg.sgdboop.enable inputs.nixpkgs-master.legacyPackages.${pkgs.system}.sgdboop)
        (lib.mkIf cfg.osu-lazer.enable osu-lazer-bin)
        (lib.mkIf cfg.vkbasalt.enable vkbasalt)
        (lib.mkIf cfg.yuzu.enable (pkgs.callPackage ./yuzu {inherit npins;}).eden)
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
