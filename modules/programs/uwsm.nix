{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.uwsm;
in {
  options.cfg.programs.uwsm.enable = mkEnableOption "uwsm";
  config = mkIf cfg.enable {
    programs.uwsm.enable = true;
    xdg.terminal-exec = {
      enable = true;
      settings = {
        Hyprland = ["foot.desktop"];
      };
    };
    environment = {
      systemPackages = [pkgs.app2unit];
      sessionVariables = {
        UWSM_SILENT_START = 1;
        # uwsm integration
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        APP2UNIT_TYPE = "scope";
      };
    };
  };
}
