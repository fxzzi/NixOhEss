{ config, pkgs, inputs, lib, ... }:

{
  programs.hyprland = {
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    enable = true;
    withUWSM = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-media-tags-plugin ]; # Enable some plugins for archive support
  };

  programs.file-roller.enable = true; # Enable File Roller for GUI archive management

  environment.systemPackages = with pkgs; [
    dunst
    libcanberra-gtk3
    papirus-icon-theme
    wl-clipboard
    mate.mate-polkit
    xdg-utils
    glib
    xorg.xrandr
    vesktop
    grim
    slurp
    foot
    wleave
    wallust
    ags
    uwsm
    hyprpaper
    hyprsunset
    fuzzel
    pywalfox-native
    kdePackages.qt6ct
  ];

  nixpkgs.overlays = [
    (final: prev: {
      # replace foot with foot-transparency
      foot = prev.foot.overrideAttrs (old: {
        src = pkgs.fetchFromGitea {
          domain = "codeberg.org";
          owner = "fazzi";
          repo = "foot";
          rev = "transparency_yipee";
          sha256 = "sha256-b632RW/88y+Rkxkpv9x2HZyp81QcOf4ASgr3z3vrB+A=";
        };
      });

      # Overlay to add libdbusmenu-gtk3 to ags
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });
      # Make pywalfox use the more recent ver
      pywalfox-native = prev.python3.pkgs.buildPythonApplication {
        pname = "pywalfox-native";
        version = "2.8.0rc1";

        src = prev.fetchurl {
          url = "https://test-files.pythonhosted.org/packages/89/a1/8e011e2d325de8e987f7c0a67222448b252fc894634bfa0d3b3728ec6dbf/pywalfox-2.8.0rc1.tar.gz";
          sha256 = "89e0d7a441eb600933440c713cddbfaecda236bde7f3f655db0ec20b0ae12845";
        };
      };
    })
  ];
}
