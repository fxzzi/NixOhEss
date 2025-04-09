{
  lib,
  config,
  pkgs,
  npins,
  ...
}: {
  options.cfg.wayland.uwsm.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables UWSM and other related pkgs like app2unit and xdg-terminal-exec";
  };
  config = lib.mkIf config.cfg.wayland.uwsm.enable {
    programs.uwsm.enable = true;
    environment = {
      systemPackages = [
        (pkgs.callPackage ./app2unit.nix {
          inherit npins;
        })
        (pkgs.callPackage ./xdg-terminal-exec.nix {
          inherit npins;
        })
      ];
      sessionVariables = {
        # uwsm integration
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        APP2UNIT_TYPE = "scope";
      };
    };
  };
}
