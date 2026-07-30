{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.mullvad;
in {
  options.cfg.services.mullvad.enable = mkEnableOption "Mullvad VPN";
  config = mkIf cfg.enable {
    services = {
      mullvad-vpn = {
        enable = true;
        gui.enable = true;
        enableExcludeWrapper = false; # i do not use the wrapper
      };
    };
  };
}
