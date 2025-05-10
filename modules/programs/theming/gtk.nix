{
  pkgs,
  inputs,
  ...
}: let
  gtkConf = ''
    [Settings]
    gtk-theme-name=tokyonight
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=Sans Regular 11
  '';
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
        (pkgs.catppuccin-papirus-folders.override
          {
            flavor = "macchiato";
            accent = "blue";
          })
      ];
    };
    programs.hyprland.settings.exec = [
      "dconf reset -f /" # bring back to a reproducible state aka empty

      "dconf write /org/gnome/desktop/interface/gtk-theme \"'tokyonight'\""
      "dconf write /org/gnome/desktop/interface/icon-theme \"'Papirus-Dark'\""
      "dconf write /org/gnome/desktop/interface/font-name \"'Sans Regular 11'\""
    ];
  };
}
