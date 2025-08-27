{
  lib,
  pkgs,
  config,
  npins,
  ...
}: let
  inherit (lib) mkIf gvariant;
  cfg = config.programs.hyprland;
in {
  config = mkIf cfg.enable {
    environment.sessionVariables = {
      HYPRCURSOR_THEME = "Bibata-original";
      HYPRCURSOR_SIZE = 24;
      XCURSOR_THEME = "Bibata-Original-Classic";
      XCURSOR_SIZE = 24;
      # as a list makes this append to instead of overwrite.
      XCURSOR_PATH = ["${pkgs.bibata-cursors}/share/icons"];
    };
    hj = {
      xdg = {
        # idk why some files read from here, but if you're ever having
        # problems with cursor themes not working on some apps, try this.
        data.files."icons/default/index.theme" = {
          generator = lib.generators.toINI {};
          value = {
            "Icon Theme".Inherits = "Bibata-Original-Classic";
          };
        };
      };
      packages = [
        (pkgs.callPackage "${npins.niqspkgs}/pkgs/bibata-hyprcursor/package.nix" {
          variant = "original";
        })
        pkgs.bibata-cursors
      ];
    };
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = "Bibata-Original-Classic";
            cursor-size = gvariant.mkInt32 24;
          };
        };
      }
    ];
  };
}
