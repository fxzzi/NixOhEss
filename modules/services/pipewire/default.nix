{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.pipewire;
in {
  options.cfg.services.pipewire.enable = mkEnableOption "pipewire";
  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    hj.packages = with pkgs; [
      qpwgraph
      pwvucontrol
    ];
    # NOTE: If we're using sched-ext, we shouldn't use rt in any way.
    # see: https://github.com/sched-ext/scx/issues/2496
    security.rtkit = mkIf (!config.cfg.services.scx.enable) {
      enable = true;
      # https://wiki.archlinux.org/title/PipeWire#Missing_realtime_priority/crackling_under_load_after_suspend
      args = ["--no-canary"];
    };
    users.users.${config.cfg.core.username}.extraGroups = [
      "audio"
      "pipewire"
    ];
  };
}
