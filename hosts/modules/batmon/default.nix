{
  inputs,
  lib,
  config,
  ...
}: {
  options.cfg.batmon.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables batmon to manage power profiles on laptops.";
  };
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
