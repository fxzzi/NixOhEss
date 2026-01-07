{pkgs, ...}: let
  noRounding = ''
    window {
      border-radius: 0;
    }
  '';
in {
  config = {
    hj = {
      packages = [
        pkgs.adw-gtk3
        pkgs.papirus-icon-theme
      ];
      # remove all rounding on gtk windows
      xdg.config.files."gtk-4.0/gtk.css".text = noRounding;
      xdg.config.files."gtk-3.0/gtk.css".text = noRounding;
    };
    environment.sessionVariables = {
      # mate-polkit seems to read from this env var. maybe other apps too
      GTK_THEME = "adw-gtk3-dark:dark";
    };
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "adw-gtk3-dark";
            icon-theme = "Papirus-Dark";
            font-name = "Sans Regular 11";
            document-font-name = "Sans Regular 11";
            monospace-font-name = "Monospace Regular 12";
            color-scheme = "prefer-dark";

            gtk-enable-primary-paste = false; # disable middle click paste
          };
          "org/gnome/desktop/wm/preferences" = {
            # hide all title bar buttons on gtk apps
            button-layout = ":";
          };
        };
      }
    ];
  };
}
