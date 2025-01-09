{
  inputs,
  lib,
  config,
  ...
}: {
  options.batmon.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables batmon to manage power profiles on laptops.";
  };
  config = lib.mkIf config.batmon.enable {
    services.power-profiles-daemon.enable = true;
    services.upower = {
      enable = true;
    };
    services.batmon = {
      enable = true;
      settings = {
        batPaths = [
          {
            path = "/sys/class/power_supply/BAT0";
          }
        ];
      };
    };
  };
  imports = [inputs.batmon.nixosModules.batmon];
}
