{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cfg.services.watt;
in {
  options.cfg.services.watt.enable = mkEnableOption "watt";
  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = mkForce false;
      watt.enable = true;
    };
    systemd.services.watt.serviceConfig.Environment = [
      "WATT_CONFIG=/etc/watt.toml"
    ];
    environment.etc."watt.toml".text = mkForce ''
      [[rule]]
      if       = "?discharging"
      priority = 99

      cpu.energy-performance-preference = { if = { is-energy-performance-preference-available = "power" }, then = "power" }
      cpu.governor                      = { if = { is-governor-available = "powersave" }, then = "powersave" }
      cpu.turbo                         = { if = "?turbo-available", then = false }

      power.platform-profile            = { if = { is-platform-profile-available = "low-power" }, then = "low-power" }

      [[rule]]
      if.not   = "?discharging"
      priority = 100

      cpu.energy-performance-preference = { if = { is-energy-performance-preference-available = "performance" }, then = "performance" }
      cpu.governor                      = { if = { is-governor-available = "performance" }, then = "performance" }
      cpu.turbo                         = { if = "?turbo-available", then = true }

      power.platform-profile            = { if = { is-platform-profile-available = "performance" }, then = "performance" }
    '';
  };
  imports = [inputs.watt.nixosModules.default];
}
