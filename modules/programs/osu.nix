{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.osu;
in {
  options.cfg.programs.osu.enable = mkEnableOption "osu!";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.osu-lazer-bin];

    # if otd is disabled, still allow the osu internal tablet driver to work.
    services.udev.packages = lib.mkIf (!config.cfg.services.opentabletdriver.enable) [pkgs.opentabletdriver];
    boot.blacklistedKernelModules = lib.mkIf (!config.cfg.services.opentabletdriver.enable) config.hardware.opentabletdriver.blacklistedKernelModules;
  };
}
