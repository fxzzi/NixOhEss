{
  pkgs,
  npins,
  ...
}: let
  pin = npins.Tokyo-Night-Linux;
in {
  config = {
    # GTK4 apps seem to need this `:dark` part to actually use dark theme
    environment.sessionVariables.GTK_THEME = "tokyonight:dark";
    hj = {
      xdg.data.files."themes/tokyonight".source = "${pin}/usr/share/themes/TokyoNight";
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
