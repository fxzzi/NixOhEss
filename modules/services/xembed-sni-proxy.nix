{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.wayland.xembed-sni-proxy.enable = lib.mkEnableOption "XEmbed SNI Proxy";
  config = lib.mkIf config.cfg.wayland.xembed-sni-proxy.enable {
    systemd.user.services.xembed-sni-proxy = {
      enable = true;
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
      };
      serviceConfig = {
        ExecStart = "${lib.getExe' pkgs.kdePackages.plasma-workspace "xembedsniproxy"}";
        Restart = "on-abort";
      };
    };
  };
}
