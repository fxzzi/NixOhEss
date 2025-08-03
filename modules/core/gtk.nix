{
  pkgs,
  npins,
  ...
}: let
  pin = npins.Tokyo-Night-Linux;

  gtkConf = ''
    [Settings]
    gtk-theme-name=tokyonight
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=Sans Regular 11
    gtk-application-prefer-dark-theme=true

  '';
in {
  config = {
    environment = {
      sessionVariables = {
        GTK_THEME = "tokyonight:dark";
      };
    };
    hj = {
      xdg = {
        data.files."themes/tokyonight".source = "${pin}/usr/share/themes/TokyoNight";
        config = {
          files = {
            "gtk-3.0/settings.ini".text = gtkConf;
            "gtk-4.0/settings.ini".text = gtkConf;
          };
        };
      };
      packages = [
        pkgs.papirus-icon-theme
      ];
    };
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "tokyonight";
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
