{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.mullvad;
in
{
  options.cfg.services.mullvad.enable = mkEnableOption "Mullvad VPN";
  config = mkIf cfg.enable {
    services = {
      mullvad-vpn = {
        enable = true;
        gui.enable = true;
        enableExcludeWrapper = false; # i do not use the wrapper
        # mullvad uses cgroup v1 by default, which breaks stuff
        # in polkit for run0 persistentAuth / keep_auth
        # make it use cgroup2 instead
        package = pkgs.mullvad.overrideAttrs (old: {
          cargoBuildFeatures = (old.cargoBuildFeatures or [ ]) ++ [
            "mullvad-daemon/cgroup2"
            "mullvad-exclude/cgroup2"
          ];
        });
      };
    };
  };
}
