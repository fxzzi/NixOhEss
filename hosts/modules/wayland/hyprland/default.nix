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
    programs.uwsm.enable = true;
    programs.hyprland = {
      enable = true;
      package = pkg.hyprland;
      portalPackage = pkg.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };
  };
}
