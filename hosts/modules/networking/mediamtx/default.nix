{ lib, config, ... }:
{
  options.netConfig.mediamtx.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the mediamtx service for local webRTC streaming.";
  };
  config = lib.mkIf config.netConfig.mediamtx.enable {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        4200
      ];
      allowedUDPPorts = [
        4200
      ];
    };
    services.mediamtx = {
      enable = true;
      settings = {
        webrtc = true;
        webrtcAddress = ":4200";
        webrtcLocalUDPAddress = ":4200";
        webrtcAdditionalHosts = [ ];
        paths = {
          all_others = { };
        };
      };
    };
  };
}
