{
  lib,
  config,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf toInt;
  cfg = config.cfg.services.mediamtx;
  port = "4200";
in {
  options.cfg.services.mediamtx.enable = mkEnableOption "mediamtx";
  config = mkIf cfg.enable {
    age.secrets.publicip.file = "${self}/parts/secrets/publicip.age";
    networking.firewall = {
      allowedTCPPorts = [(toInt port)];
      allowedUDPPorts = [(toInt port)];
    };
    services.mediamtx = {
      enable = true;
      settings = {
        webrtc = true;
        webrtcAddress = ":${port}";
        webrtcLocalUDPAddress = ":${port}";
        # allow publishing to all paths
        paths = {
          all_others = {};
          # fazzi = {
          #   alwaysAvailable = true;
          #   alwaysAvailableTracks = [
          #     {codec = "Opus";}
          #     {codec = "H264";}
          #   ];
          # };
        };
        writeQueueSize = 2048;
      };
    };
    # NOTE: pass the public ip to mediamtx via env var
    # secret should be in the form MTX_WEBRTCADDITIONALHOSTS=publicip1,publicip2,...
    systemd.services.mediamtx.serviceConfig.EnvironmentFile = "${config.age.secrets.publicip.path}";
  };
}
