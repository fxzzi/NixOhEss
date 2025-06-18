{
  inputs,
  lib,
  config,
  ...
}: {
  options.cfg.watt.enable = lib.mkEnableOption "watt";
  config = lib.mkIf config.cfg.watt.enable {
    services = {
      power-profiles-daemon.enable = lib.mkForce false;
      watt = {
        enable = true;
        settings = {
          # use powersaving on battery and performance on charger
          charger = {
            governor = "powersave";
            epp = "performance";
            epb = "balance_performance";
            platform_profile = "performance";
            turbo = "auto";
          };
          battery = {
            governor = "powersave";
            epp = "power";
            epb = "balance_power";
            platform_profile = "low-power";
            turbo = "auto";
          };

          daemon = {
            poll_interval_sec = 4;
            adaptive_interval = true;
            min_poll_interval_sec = 1;
            max_poll_interval_sec = 30;
            throttle_on_battery = true;
          };
        };
      };
    };
  };
  imports = [inputs.watt.nixosModules.default];
}
