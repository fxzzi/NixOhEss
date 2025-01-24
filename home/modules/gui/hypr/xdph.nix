{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  hyprFlake = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.gui.hypr.xdph.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables xdph and its configs.";
  };
  config = lib.mkIf config.gui.hypr.xdph.enable {
    xdg.portal = {
      enable = true;
      config.common.default = "hyprland";
      configPackages = [
        hyprFlake.xdg-desktop-portal-hyprland
      ];
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };

    home.file."${config.xdg.configHome}/hypr/xdph.conf".text = ''
      screencopy {
      	max_fps = 60
      }
    '';
  };
}
