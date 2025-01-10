{
  lib,
  config,
  pkgs,
  ...
}: 
let
  port = "4200";
in
{
  options.netConfig.mediamtx.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the mediamtx service for local webRTC streaming.";
  };
  config = lib.mkIf config.netConfig.mediamtx.enable {
    age.secrets.localip.file = ../../../../secrets/localip.age;
		# This is super hacky. I shouldn't have to do this. I won't have to do
		# this once / if mediamtx allows reading IPs from a path. See:
		# https://github.com/bluenviron/mediamtx/issues/4109#issuecomment-2581174785
    system.activationScripts."localip" = ''
      secret=$(cat "${config.age.secrets.localip.path}")
      configFile=/etc/mediamtx.yaml
      ${pkgs.gnused}/bin/sed -i -e "s#'@localip@'#$secret#g" "$configFile"
    '';
    networking.firewall = {
      allowedTCPPorts = [
        (lib.toInt port)
      ];
      allowedUDPPorts = [
        (lib.toInt port)
      ];
    };
    services.mediamtx = {
      enable = true;
      settings = {
        webrtc = true;
        webrtcAddress = ":${port}";
        webrtcLocalUDPAddress = ":${port}";
        webrtcAdditionalHosts = [
          "@localip@"
        ];
        paths = {
          fazzi = {};
        };
      };
    };
  };
}
