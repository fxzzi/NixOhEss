{
  pkgs,
  ...
}:
let
  alsa-ucm-conf' = pkgs.alsa-ucm-conf.overrideAttrs {
    patches = [
      # USB-Audio/EVO4: correct naming scheme for Master Playback
      (pkgs.fetchpatch {
        url = "https://github.com/alsa-project/alsa-ucm-conf/commit/cd50898a4956b26ec038b64a8286282d263a5885.patch";
        hash = "sha256-T/k/pXJ3hhYOaL9Wy4qaz1g4FEb+4VVW3DcVbTi5Nsc=";
      })
      # USB-Audio/EVO4: correct typo for loopback priority
      (pkgs.fetchpatch {
        url = "https://github.com/alsa-project/alsa-ucm-conf/commit/5cfb36fdb86a9ca83093d92cba33f1045a172bcc.patch";
        hash = "sha256-kC0o0hnCumVqpYiSjhl0cjdI9+cDhaEnOruQLM1o/DY=";
      })
    ];
  };

  extraEnv.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
in
{
  config = {
    # save the EVO4 options in ALSA, including mic gain, phantom power, etc.
    hardware.alsa.enablePersistence = true;
    # use patched UCM conf
    systemd.user.services = {
      pipewire.environment = extraEnv;
      wireplumber.environment = extraEnv;
    };
  };
}
