{
  lib,
  config,
  pkgs,
  ...
}: let
  port = "4200";
  localips = builtins.map (item: item.address) config.networking.interfaces.enp6s0.ipv4.addresses;
in {
  options.cfg.netConfig.mediamtx.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the mediamtx service for local webRTC streaming.";
  };
  config = lib.mkIf config.cfg.netConfig.mediamtx.enable {
    age.secrets.localip.file = ../../../../secrets/localip.age;
    # HACK: This is super hacky. I shouldn't have to do this. I won't have to do
    # this once / if mediamtx allows reading IPs from a path.
    # https://github.com/bluenviron/mediamtx/issues/4109#issuecomment-2581174785
    system.activationScripts.localip = {
      text = ''
        secret=$(cat "${config.age.secrets.localip.path}")
        configFile=/etc/mediamtx.yaml
        ${pkgs.gnused}/bin/sed -i -e "s#'@localip@'#$secret#g" "$configFile"
      '';
    };
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
        webrtcAdditionalHosts =
          ["@localip@"] # for agenix to replace after
          ++ config.networking.nameservers
          ++ localips;
        paths = {
          all_others = {};
        };
      };
    };
  };
}
