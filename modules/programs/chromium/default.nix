{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionals concatStringsSep;
  cfg = config.cfg.programs.chromium;
  newTabPage = "file:///home/${config.cfg.core.username}/.local/share/startpage/${config.cfg.programs.startpage.user}/index.html";

  disableFeatures = [
    "WebRtcAllowInputVolumeAdjustment"
    "ChromeWideEchoCancellation"
  ];
  enableFeatures =
    [
      "AcceleratedVideoDecodeLinuxGL"
      "AcceleratedVideoDecodeLinuxZeroCopyGL"
      "VaapiIgnoreDriverChecks"
    ]
    ++ optionals config.cfg.hardware.nvidia.enable [
      "WaylandLinuxDrmSyncobj" # fix flickering
      "VaapiOnNvidiaGPUs"
    ];

  commandLineArgs =
    [
      "--extension-mime-request-handling=always-prompt-for-install"
    ]
    ++ optionals (enableFeatures != []) [
      "--enable-features=${concatStringsSep "," enableFeatures}"
    ]
    ++ optionals (disableFeatures != []) [
      "--disable-features=${concatStringsSep "," disableFeatures}"
    ]
    ++ optionals (!config.cfg.programs.smoothScroll.enable) [
      "--disable-smooth-scrolling"
    ]
    ++ optionals config.cfg.programs.startpage.enable [
      "--custom-ntp=${newTabPage}"
    ];

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
    via.enable = mkEnableOption "via";
  };
  config = mkIf cfg.enable {
    hj = {
      packages = [
        (pkgs.ungoogled-chromium.override {
          inherit commandLineArgs;
        })
        (mkIf cfg.wootility.enable wootility)
        (mkIf cfg.scyrox-s-center.enable scyrox-s-center)
        (mkIf cfg.via.enable via)
      ];
    };
  };
}
