{
  pkgs,
  inputs,
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
        ".local/share/themes/tokyonight".source = "${inputs.tokyo-night-linux}/usr/share/themes/TokyoNight";
        ".config/gtk-3.0/settings.ini".text = gtkConf;
        ".config/gtk-4.0/settings.ini".text = gtkConf;
      };
      packages = with pkgs; [
        (catppuccin-papirus-folders.override
          {
            flavor = "macchiato";
            accent = "blue";
          })
      ];
    };
    systemd.user.services.dconf-gtk = {
      enable = true;
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "Set dconf theming settings";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };
      script = ''
        ${dconf} write /org/gnome/desktop/interface/gtk-theme \"'tokyonight'\"
        ${dconf} write /org/gnome/desktop/interface/icon-theme \"'Papirus-Dark'\"
        ${dconf} write /org/gnome/desktop/interface/font-name \"'Sans Regular 11'\"
        ${dconf} write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\"
      '';
    };
  };
}
