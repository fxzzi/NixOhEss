{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    optionals
    concatStringsSep
    ;
  cfg = config.cfg.programs.chromium;

  disableFeatures = [
    # stop allowing chromium / electron to adjust your mic gain
    "WebRtcAllowInputVolumeAdjustment"
  ];
  enableFeatures = [
    # vaapi info: https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/gpu/vaapi.md
    "AcceleratedVideoDecodeLinuxGL"
    "AcceleratedVideoDecodeLinuxZeroCopyGL"
    "AcceleratedVideoEncoder"
    "VaapiOnNvidiaGPUs"
    "WaylandLinuxDrmSyncobj" # fix flickering on nvidia
    "MiddleClickAutoscroll"
  ];

  commandLineArgs = [
    # hdr, wcg
    "--enable-experimental-web-platform-features"
    # allow installing ungoogled-chromium webstore stuff
    "--extension-mime-request-handling=always-prompt-for-install"
    # stop begging to be the default browser dude, you ain't firefox
    "--no-default-browser-check"
  ]
  ++ optionals config.cfg.programs.startpage.enable [
    "--custom-ntp=${config.cfg.programs.startpage.page}"
  ]
  ++ optionals (enableFeatures != [ ]) [
    "--enable-features=${concatStringsSep "," enableFeatures}"
  ]
  ++ optionals (disableFeatures != [ ]) [
    "--disable-features=${concatStringsSep "," disableFeatures}"
  ]
  ++ optionals (!config.cfg.programs.smoothScroll.enable) [
    "--disable-smooth-scrolling"
  ];

  wootility = pkgs.makeDesktopItem {
    name = "wootility";
    desktopName = "Wootility Web";
    exec = "chromium --app=https://beta.wootility.io/ %U";
    terminal = false;
    icon = ./icons/wootility-web.svg;
  };
  scyrox-s-center = pkgs.makeDesktopItem {
    name = "scyrox-s-center";
    desktopName = "Scyrox S-center";
    exec = "chromium --app=https://www.scyrox.net/ %U";
    terminal = false;
    icon = ./icons/scyrox-s-center.svg;
  };
  mchose-m-hub = pkgs.makeDesktopItem {
    name = "mchose-m-hub";
    desktopName = "MCHOSE M HUB";
    exec = "chromium --app=https://www.mchose.com.cn/ %U";
    terminal = false;
    icon = ./icons/mchose-m-hub.svg;
  };
  via = pkgs.makeDesktopItem {
    name = "via";
    desktopName = "VIA";
    exec = "chromium --app=https://usevia.app/ %U";
    terminal = false;
    icon = ./icons/via.svg;
  };
in
{
  options.cfg.programs.chromium = {
    enable = mkEnableOption "chromium";
    wootility.enable = mkEnableOption "wootility";
    scyrox-s-center.enable = mkEnableOption "scyrox-s-center";
    mchose-m-hub.enable = mkEnableOption "mchose-m-hub";
    via.enable = mkEnableOption "via";
  };
  config = {
    hj = mkIf cfg.enable {
      packages = [
        (pkgs.ungoogled-chromium.override {
          inherit commandLineArgs;
        })
        (mkIf cfg.wootility.enable wootility)
        (mkIf cfg.scyrox-s-center.enable scyrox-s-center)
        (mkIf cfg.mchose-m-hub.enable mchose-m-hub)
        (mkIf cfg.via.enable via)
      ];
    };
  };
}
