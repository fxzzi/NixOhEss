{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.hyprsunset;
in
{
  options.cfg.services.hyprsunset.enable = mkEnableOption "hyprsunset";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.hyprsunset
      ];
    };
    hj.systemd.services.hyprsunset = self.lib.mkGraphicalService {
      description = "Hyprsunset blue light filter";
      # --identity starts hyprsunset without changing temperature
      exec = "${getExe pkgs.hyprsunset} --identity";
    };
  };
}
