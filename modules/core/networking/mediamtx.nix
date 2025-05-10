{
  lib,
  config,
  pkgs,
  ...
}: let
  port = "4200";
  localips = builtins.concatLists (
    builtins.map (iface: builtins.map (addr: addr.address) iface.ipv4.addresses) (
      builtins.attrValues config.networking.interfaces
    )
  );
in {
  options.cfg.networking.mediamtx.enable = lib.mkEnableOption "mediamtx";
  config = lib.mkIf config.cfg.networking.mediamtx.enable {
    age.secrets.publicip.file = ../../../secrets/publicip.age;
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
          ["@publicip@"] # for agenix to replace after
          ++ config.networking.nameservers
          ++ localips;
        # allow publishing to all paths
        paths = {
          all_others = {};
        };
      };
    };
  };
}
