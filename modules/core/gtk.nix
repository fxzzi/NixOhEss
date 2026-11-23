{
  pkgs,
  ...
}:
{
  config = {
    hj = {
      packages = [
        pkgs.adw-gtk3
        pkgs.papirus-icon-theme
      ];
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
            enable-animations = false;
          };
          "org/gnome/desktop/wm/preferences" = {
            # hide all title bar buttons on gtk apps
            button-layout = ":";
          };
          "com/stremio/stremio" = {
            # hide window decor in stremio-linux-shell
            no-window-decorations = true;
          };
        };
      }
    ];
  };
}
