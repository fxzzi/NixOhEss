{
  lib,
  pkgs,
  config,
  user,
  ...
}: let
  newTabPage = "file:///home/${user}/.local/share/startpage/${config.cfg.apps.browsers.startpage.user}/index.html";
  commandLineArgs =
    [
      "--disable-features=WebRtcAllowInputVolumeAdjustment" # stop chromium from messing with my mic volume
      "--extension-mime-request-handling=always-prompt-for-install" # allow chrome web store extension to be installed
    ]
    ++ lib.optionals config.cfg.gpu.nvidia.enable [
      "--enable-features=WaylandLinuxDrmSyncobj" # fix flickering
      # attempt to enable hardware acceleration
      "--enable-features=AcceleratedVideoDecodeLinuxGL"
      "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL"
      "--enable-features=VaapiOnNvidiaGPUs"
      "--enable-features=VaapiIgnoreDriverChecks"
    ]
    ++ lib.optionals (!config.cfg.gui.smoothScroll.enable) [
      "--disable-smooth-scrolling"
    ]
    ++ lib.optionals config.cfg.apps.browsers.startpage.enable [
      # override new tab page
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
  options.cfg.apps.browsers.chromium = {
    enable = lib.mkEnableOption "chromium";
    wootility.enable = lib.mkEnableOption "wootility";
    scyrox-s-center.enable = lib.mkEnableOption "scyrox-s-center";
    via.enable = lib.mkEnableOption "via";
  };
  config = lib.mkIf config.cfg.apps.browsers.chromium.enable {
    hj = {
      packages = [
        (pkgs.ungoogled-chromium.override {
          inherit commandLineArgs;
        })
        (lib.mkIf config.cfg.apps.browsers.chromium.wootility.enable wootility)
        (lib.mkIf config.cfg.apps.browsers.chromium.scyrox-s-center.enable scyrox-s-center)
        (lib.mkIf config.cfg.apps.browsers.chromium.via.enable via)
      ];
    };
  };
}
