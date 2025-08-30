{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf toInt;
  inherit (builtins) concatLists map attrValues;
  cfg = config.cfg.services.mediamtx;
  port = "4200";
  # get all assigned local ips
  localips = concatLists (map (iface: map (addr: addr.address) iface.ipv4.addresses) (attrValues config.networking.interfaces));
  # mediamtx doesnt support ipv6, and it fails to work if there is one present. so filter for ipv4 only
in {
  options.cfg.services.mediamtx.enable = mkEnableOption "mediamtx";
  config = mkIf cfg.enable {
    age.secrets.publicip.file = ../../secrets/publicip.age;
    networking.firewall = {
      allowedTCPPorts = [
        (toInt port)
      ];
      allowedUDPPorts = [
        (toInt port)
      ];
    };
    services.mediamtx = {
      enable = true;
      settings = {
        webrtc = true;
        webrtcAddress = ":${port}";
        webrtcLocalUDPAddress = ":${port}";
        webrtcAdditionalHosts =
          [
            "1.1.1.1"
            "1.0.0.1"
          ]
          ++ localips;
        # allow publishing to all paths
        paths = {
          all_others = {};
        };
      };
    };
    # NOTE: pass the public ip to mediamtx via env var
    # secret should be in the form MTX_WEBRTCADDITIONALHOSTS=publicip
    systemd.services.mediamtx.serviceConfig.EnvironmentFile = "${config.age.secrets.publicip.path}";
  };
}
