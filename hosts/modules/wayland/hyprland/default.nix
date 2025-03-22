{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  pkg =
    if config.cfg.wayland.hyprland.useGit
    then inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
  patches =
    if config.cfg.wayland.hyprland.useGit
    then [
      # NOTE: add patches to hyprland here!

      # (pkgs.fetchpatch
      #   {
      #     url = "https://github.com/hyprwm/Hyprland/pull/9678.patch";
      #     sha256 = "sha256-krpzC8AkzL5JyV0xXxQzG4cXazK6cP9422mnYa6c33s=";
      #   })
    ]
    else [];
in {
  options.cfg.wayland.hyprland.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the Hyprland compositor and xdg portal.";
  };
  options.cfg.wayland.hyprland.useGit = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Makes hm and nix use hypr* packages from flakes instead of nixpkgs";
  };
  config = lib.mkIf config.cfg.wayland.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = pkg.hyprland.overrideAttrs {
        inherit patches;
      };
      portalPackage = pkg.xdg-desktop-portal-hyprland;
      withUWSM = config.cfg.wayland.uwsm.enable;
    };
  };
}
