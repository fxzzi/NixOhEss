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
    # HACK: This is super hacky. I shouldn't have to do this. I won't have to do
    # this once / if mediamtx allows reading IPs from a path.
    # https://github.com/bluenviron/mediamtx/issues/4109#issuecomment-2581174785
    system.activationScripts.localip = {
      text = ''
        secret=$(cat "${config.age.secrets.publicip.path}")
        configFile=/etc/mediamtx.yaml
        ${pkgs.gnused}/bin/sed -i -e "s#'@publicip@'#$secret#g" "$configFile"
      '';
    };
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
            "@publicip@" # @publicip@ is later replaced by agenix
          ]
          ++ localips;
        # allow publishing to all paths
        paths = {
          all_others = {};
        };
      };
    };
  };
}
