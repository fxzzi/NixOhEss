{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.wayland.hyprland.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the Hyprland compositor and xdg portal.";
  };
  config = lib.mkIf config.wayland.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
