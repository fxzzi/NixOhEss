{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.wayland.uwsm.enable = lib.mkEnableOption "uwsm";
  config = lib.mkIf config.cfg.wayland.uwsm.enable {
    programs.uwsm.enable = true;
    xdg.terminal-exec = {
      enable = true;
      settings = {
        Hyprland = [
          "foot.desktop"
        ];
      };
    };
    environment = {
      systemPackages = [
        pkgs.app2unit
      ];
      sessionVariables = {
        UWSM_SILENT_START = 1;
        # uwsm integration
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        APP2UNIT_TYPE = "scope";
      };
    };
  };
}
