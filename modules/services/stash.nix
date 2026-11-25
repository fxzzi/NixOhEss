{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.stash;
in
{
  options.cfg.services.stash.enable = mkEnableOption "stash";
  config = mkIf cfg.enable {
    hj = {
      # provides wl-copy/wl-paste too
      packages = [ pkgs.stash-clipboard ];
      systemd.services = {
        stash = self.lib.mkGraphicalService {
          description = ''Wayland clipboard "manager" with fast persistent history and multi-media support'';
          exec = "${getExe pkgs.stash-clipboard} --max-items 24 --min-size 2 watch";
          extra.restartTriggers = [ pkgs.stash-clipboard ];
        };
      };
    };
  };
}
