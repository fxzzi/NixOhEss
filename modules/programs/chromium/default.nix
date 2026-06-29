{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types optionals concatStringsSep;
  cfg = config.cfg.programs.chromium;
  disableFeatures = [
    "WebRtcAllowInputVolumeAdjustment"
    # "ChromeWideEchoCancellation"
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

  commonArgs =
    [
      # hdr, wcg
      "--enable-experimental-web-platform-features"
    ]
    ++ optionals (enableFeatures != []) [
      "--enable-features=${concatStringsSep "," enableFeatures}"
    ]
    ++ optionals (disableFeatures != []) [
      "--disable-features=${concatStringsSep "," disableFeatures}"
    ]
    ++ optionals (!config.cfg.programs.smoothScroll.enable) [
      "--disable-smooth-scrolling"
    ];

  commandLineArgs =
    [
      "--extension-mime-request-handling=always-prompt-for-install"
    ]
    ++ optionals config.cfg.programs.startpage.enable [
      "--custom-ntp=${config.cfg.programs.startpage.page}"
    ]
    ++ commonArgs;

  wootility = pkgs.makeDesktopItem {
    name = "wootility";
    desktopName = "Wootility Web";
    exec = "chromium --app=https://beta.wootility.io/ %U";
    terminal = false;
    icon = "${./wootility-web.svg}";
  };
  scyrox-s-center = pkgs.makeDesktopItem {
    name = "scyrox-s-center";
    desktopName = "Scyrox S-center";
    exec = "chromium --app=https://www.scyrox.net/ %U";
    terminal = false;
    icon = "${./scyrox-s-center.svg}";
  };
  mchose-m-hub = pkgs.makeDesktopItem {
    name = "mchose-m-hub";
    desktopName = "MCHOSE M HUB";
    exec = "chromium --app=https://www.mchose.com.cn/ %U";
    terminal = false;
    icon = "${./mchose-m-hub.svg}";
  };
  via = pkgs.makeDesktopItem {
    name = "via";
    desktopName = "VIA";
    exec = "chromium --app=https://usevia.app/ %U";
    terminal = false;
    icon = "${./via.svg}";
  };
in {
  options.cfg.programs.chromium = {
    enable = mkEnableOption "chromium";
    wootility.enable = mkEnableOption "wootility";
    scyrox-s-center.enable = mkEnableOption "scyrox-s-center";
    mchose-m-hub.enable = mkEnableOption "mchose-m-hub";
    via.enable = mkEnableOption "via";
    commonArgs = mkOption {
      type = types.listOf types.str;
      internal = true;
      description = "Common args for chromium and electron apps";
    };
  };
  config = {
    cfg.programs.chromium.commonArgs = commonArgs;
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
