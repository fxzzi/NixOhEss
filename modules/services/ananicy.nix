{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.ananicy;
in
{
  options.cfg.services.ananicy.enable = mkEnableOption "ananicy";
  config = mkIf cfg.enable {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;

      # <https://github.com/CachyOS/ananicy-rules/blob/a781d2c5d962c375ba189dec49f6e6633eaebc5a/ananicy.conf#L26>
      settings.cgroup_realtime_workaround = false;
    };
  };
}
