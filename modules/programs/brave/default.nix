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
  cfg = config.cfg.programs.brave;

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
    "--extension-mime-request-handling=always-prompt-for-install"
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
    exec = "brave-origin --app=https://beta.wootility.io/ %U";
    terminal = false;
    icon = ./icons/wootility-web.svg;
  };
  scyrox-s-center = pkgs.makeDesktopItem {
    name = "scyrox-s-center";
    desktopName = "Scyrox S-center";
    exec = "brave-origin --app=https://www.scyrox.net/ %U";
    terminal = false;
    icon = ./icons/scyrox-s-center.svg;
  };
  mchose-m-hub = pkgs.makeDesktopItem {
    name = "mchose-m-hub";
    desktopName = "MCHOSE M HUB";
    exec = "brave-origin --app=https://www.mchose.com.cn/ %U";
    terminal = false;
    icon = ./icons/mchose-m-hub.svg;
  };
  via = pkgs.makeDesktopItem {
    name = "via";
    desktopName = "VIA";
    exec = "brave-origin --app=https://usevia.app/ %U";
    terminal = false;
    icon = ./icons/via.svg;
  };
  eightbitdo = pkgs.makeDesktopItem {
    name = "8BitDo Web";
    desktopName = "8BitDo Web";
    exec = "brave-origin --app=https://web.8bitdo.com %U";
    terminal = false;
    icon = ./icons/8bitdo.svg;
  };
in
{
  options.cfg.programs.brave = {
    enable = mkEnableOption "brave";
    wootility.enable = mkEnableOption "wootility";
    scyrox-s-center.enable = mkEnableOption "scyrox-s-center";
    mchose-m-hub.enable = mkEnableOption "mchose-m-hub";
    via.enable = mkEnableOption "via";
    eightbitdo.enable = mkEnableOption "8bitdo";
  };
  config = {
    hj = mkIf cfg.enable {
      packages = [
        (pkgs.brave-origin.override {
          inherit commandLineArgs;
        })
        (mkIf cfg.wootility.enable wootility)
        (mkIf cfg.scyrox-s-center.enable scyrox-s-center)
        (mkIf cfg.mchose-m-hub.enable mchose-m-hub)
        (mkIf cfg.via.enable via)
        (mkIf cfg.eightbitdo.enable eightbitdo)
      ];
    };
  };
}
