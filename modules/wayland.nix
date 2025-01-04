{ pkgs, inputs, lib, ... }:

{
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
    grim
    slurp
    wleave
    wallust
    ags
    hyprpaper
    hyprsunset
    hyprlock
    hypridle
    fuzzel
    pywalfox-native
    kdePackages.qt6ct
    cmake
    meson
    cpio
    pkg-config
  ];

  nixpkgs.overlays = [
    (self: super: {
      electron_31 = self.electron;
    })
    (final: prev: {
      # replace foot with foot-transparency
      foot = prev.foot.overrideAttrs
        (old: {
          pname = "foot-transparency";
          version = "1.20.0";
          src = pkgs.fetchFromGitea {
            domain = "codeberg.org";
            owner = "fazzi";
            repo = "foot";
            rev = "transparency_yipee";
            sha256 = "sha256-R2hZTX4/CrJysbkrc8R35PhvqbJ+BG7NJyUfwfnoB8w=";
          };

          meta = {
            description = "A fork of foot - the fast wayland terminal emulator - now with more transparency options!! (git)";
            mainProgram = "foot";
            maintainers = with lib.maintainers; [ Fazzi ];
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
