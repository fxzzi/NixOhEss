{
  inputs,
  npins,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cfg.services.watt;
  compat = import npins.flake-compat;
  watt =
    (compat.load {
      src = npins.watt;

      replacements = {
        nixpkgs = compat.load {src = inputs.nixpkgs;};
      };
    }).outputs;
in {
  options.cfg.services.watt.enable = mkEnableOption "watt";
  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = mkForce false;
      watt = {
        enable = true;
        settings = {
          # use powersaving on battery and performance on charger
          charger = {
            # when using amd-pstate the governor should always be "powersave"
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
            poll_interval_sec = 5;
            adaptive_interval = true;
            min_poll_interval_sec = 1;
            max_poll_interval_sec = 30;
            throttle_on_battery = true;
          };
        };
      };
    };
  };
  imports = [watt.nixosModules.default];
}
