{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.mullvad;
in {
  options.cfg.services.mullvad.enable = lib.mkEnableOption "Mullvad VPN";
  config = mkIf cfg.enable {
    services = {
      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn; # mullvad gui
        enableExcludeWrapper = false; # i do not use the wrapper
      };
    };
  };
}
