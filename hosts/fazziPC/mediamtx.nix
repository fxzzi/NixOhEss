{
  lib,
  config,
  self,
  ...
}:
let
  inherit (lib) toInt;
  port = "4200";
in
{
  config = {
    age.secrets.publicip.file = "${self}/secrets/publicip.age";
    networking.firewall = {
      allowedTCPPorts = [ (toInt port) ];
      allowedUDPPorts = [ (toInt port) ];
    };
    services.mediamtx = {
      enable = true;
      settings = {
        webrtc = true;
        webrtcAddress = ":${port}";
        webrtcLocalUDPAddress = ":${port}";
        paths = {
          fazzi = { };
        };
        writeQueueSize = 2048;
      };
    };
    # pass the public ip to mediamtx via env var
    # secret should be in the form MTX_WEBRTCADDITIONALHOSTS=publicip1,publicip2,...
    systemd.services.mediamtx.serviceConfig.EnvironmentFile = "${config.age.secrets.publicip.path}";
  };
}
