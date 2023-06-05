{ config, pkgs, inputs, ... }:

{
  programs.hyprland = {
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.override {
            nvidiaPatches = true; # Enable hyprland nvidia patches for shitty gpu
      };
    enable = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-media-tags-plugin ]; # Enable some plugins for archive support
  };

  programs.file-roller.enable = true; # Enable File Roller for GUI archive management
  
  # Patch waybar to enable the hyprland/workspaces module
  nixpkgs.overlays = [
    (final: prev: {
      waybar =
        let
          hyprctl = "${pkgs.hyprland}/bin/hyprctl";
          waybarPatchFile = import ../patches/waybar.nix { inherit pkgs hyprctl; };
        in
        prev.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          patches = (oldAttrs.patches or [ ]) ++ [ waybarPatchFile ];
        });
    })
  ];

  environment.systemPackages = with pkgs; [
    waybar
    rofi-wayland
    dunst
    swaybg
    libcanberra-gtk3
    papirus-icon-theme
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    wl-clipboard
    mate.mate-polkit
    xdg-utils
    glib
    xorg.xrandr
    webcord-vencord
    grim
    slurp
  ];
}
