{pkgs, ...}: {
  config = {
    hj = {
      packages = [
        pkgs.adw-gtk3
        pkgs.papirus-icon-theme
      ];
      xdg.config.files."gtk-4.0/gtk.css".text =
        #css
        ''
          window {
            border-radius: 0;
          }
        '';
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
          };
        };
      }
    ];
  };
}
