{
  inputs,
  lib,
  config,
  ...
}: {
  options.cfg.batmon.enable = lib.mkEnableOption "batmon";
  config = lib.mkIf config.cfg.batmon.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower = {
        enable = true;
      };
      batmon = {
        enable = true;
        settings = {
          batPaths = [
            {
              # the main battery on most laptops.
              path = "/sys/class/power_supply/BAT0";
            }
          ];
        };
      };
    };
  };
  imports = [inputs.batmon.nixosModules.batmon];
}
