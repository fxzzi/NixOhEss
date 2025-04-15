{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  newTabPage = "file://${config.xdg.dataHome}/startpage/${config.cfg.apps.browsers.startpage.user}/index.html";
in {
  options.cfg.apps.browsers.chromium = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables chromium.";
    };
    wootility.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the wootility desktop app through chromium.";
    };
    scyrox-s-center.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the Scyrox S-center desktop app through chromium.";
    };
    via.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the VIA webapp .desktop file for configuring keyboards. ";
    };
  };
  config = lib.mkIf config.cfg.apps.browsers.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs =
        [
          "--disable-features=WebRtcAllowInputVolumeAdjustment" # stop chromium from messing with my mic volume
          "--extension-mime-request-handling=always-prompt-for-install" # allow chrome web store extension to be installed
        ]
        ++ lib.optionals osConfig.cfg.gpu.nvidia.enable [
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
    };
    xdg.desktopEntries = {
      "wootility" = lib.mkIf config.cfg.apps.browsers.chromium.wootility.enable {
        name = "Wootility Web";
        exec = "chromium --app=https://beta.wootility.io/ %U";
        terminal = false;
        icon = "${./wootility-web.png}";
      };
      "scyrox-s-center" = lib.mkIf config.cfg.apps.browsers.chromium.scyrox-s-center.enable {
        name = "Scyrox S-center";
        exec = "chromium --app=https://www.scyrox.net/ %U";
        terminal = false;
        icon = "${./scyrox-s-center.png}";
      };
      "via" = lib.mkIf config.cfg.apps.browsers.chromium.via.enable {
        name = "VIA";
        exec = "chromium --app=https://usevia.app/ %U";
        terminal = false;
        icon = "${./via.svg}";
      };
    };
  };
}
