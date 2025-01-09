{
  lib,
  config,
  pkgs,
  ...
}: {
  options.netConfig.mediamtx.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the mediamtx service for local webRTC streaming.";
  };
  config = lib.mkIf config.netConfig.mediamtx.enable {
    system.activationScripts."localip" = ''
      secret=$(cat "${config.sops.secrets."mediamtx/localip".path}")
      configFile=/etc/mediamtx.yaml
      ${pkgs.gnused}/bin/sed -i -e "s#'@localip@'#$secret#g" "$configFile"
    '';
    networking.firewall = {
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
        webrtcAdditionalHosts = [
          "@localip@"
        ];
        paths = {
          all_others = {};
        };
      };
    };
  };
}
