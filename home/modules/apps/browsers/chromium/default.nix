{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: {
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
          "--disable-smooth-scrolling"
          "--disable-features=WebRtcAllowInputVolumeAdjustment" # stop chromium from messing with my mic volume
        ]
        ++ lib.optionals osConfig.cfg.gpu.nvidia.enable [
          "--enable-features=WaylandLinuxDrmSyncobj"
          "--use-cmd-decoder=passthrough"
          "--enable-gpu-rasterization"
          "--enable-zero-copy"
          "--ignore-gpu-blocklist"
          "--enable-features=AcceleratedVideoDecodeLinuxGL"
          "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL"
          "--enable-features=VaapiOnNvidiaGPUs"
          "--enable-features=VaapiIgnoreDriverChecks"
          "--enable-features=AcceleratedVideoEncoder"
          "--enable-features=AcceleratedVideoDecoder"
        ];
    };
    xdg.desktopEntries = {
      "wootility" = lib.mkIf config.cfg.apps.browsers.chromium.wootility.enable {
        name = "Wootility Web";
        exec = "${lib.getExe config.programs.chromium.package} --app=https://beta.wootility.io/ %U";
        terminal = false;
        icon = "${./wootility-web.png}";
      };
      "scyrox-s-center" = lib.mkIf config.cfg.apps.browsers.chromium.scyrox-s-center.enable {
        name = "Scyrox S-center";
        exec = "${lib.getExe config.programs.chromium.package} --app=https://www.scyrox.net/ %U";
        terminal = false;
        icon = "${./scyrox-s-center.png}";
      };
      "via" = lib.mkIf config.cfg.apps.browsers.chromium.via.enable {
        name = "VIA";
        exec = "${lib.getExe config.programs.chromium.package} --app=https://usevia.app/ %U";
        terminal = false;
        icon = "${./via.svg}";
      };
    };
  };
}
