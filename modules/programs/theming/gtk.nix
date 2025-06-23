{
  pkgs,
  npins,
  lib,
  ...
}: let
  gtkConf = ''
    [Settings]
    gtk-theme-name=tokyonight
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=Sans Regular 11
    gtk-application-prefer-dark-theme=true

  '';
  dconf = lib.getExe pkgs.dconf;
in {
  config = {
    environment = {
      sessionVariables = {
        GTK_THEME = "tokyonight:dark";
      };
    };
    hj = {
      files = {
        ".local/share/themes/tokyonight".source = "${npins.Tokyo-Night-Linux}/usr/share/themes/TokyoNight";
        ".config/gtk-3.0/settings.ini".text = gtkConf;
        ".config/gtk-4.0/settings.ini".text = gtkConf;
      };
      packages = with pkgs; [
        # stupid ass thing has long rebuilds
        # (catppuccin-papirus-folders.override
        #   {
        #     flavor = "macchiato";
        #     accent = "blue";
        #   })
        papirus-icon-theme
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
