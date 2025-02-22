{
  lib,
  pkgs,
  config,
  ...
}: {
  options.apps.browsers.chromium = {
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
  };
  config = lib.mkIf config.apps.browsers.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--disable-smooth-scrolling"
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
        "--enable-features=WaylandLinuxDrmSyncobj" # enable explicit sync support
        "--disable-features=WebRtcAllowInputVolumeAdjustment" # stop chromium from messing with my mic volume
      ];
    };
    xdg.desktopEntries = {
      # only enable the wootility app if chromium is actually enabled
      "wootility" = lib.mkIf config.apps.browsers.chromium.wootility.enable {
        name = "Wootility Web";
        exec = "${lib.getExe config.programs.chromium.package} --app=https://beta.wootility.io %U";
        terminal = false;
        icon = "${./wootility-web.png}";
      };
      "scyrox-s-center" = lib.mkIf config.apps.browsers.chromium.scyrox-s-center.enable {
        name = "Scyrox S-center";
        exec = "${lib.getExe config.programs.chromium.package} --app=https://www.scyrox.net/ %U";
        terminal = false;
        icon = "${./scyrox-s-center.png}";
      };
    };
  };
}
