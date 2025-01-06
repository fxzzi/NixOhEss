{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--disable-crash-reporter"
      "--wayland-text-input-version=3"
      "--use-cmd-decoder=passthrough"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
      "--enable-features=AcceleratedVideoDecodeLinuxGL"
      "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL"
      "--enable-features=VaapiOnNvidiaGPUs"
      "--enable-features=VaapiIgnoreDriverChecks"
    ];
  };
	# only enable the wootility app if chromium is actually enabled
  xdg.desktopEntries."wootility" = lib.mkIf config.programs.chromium.enable {
    name = "Wootility Web";
    exec = "${lib.getExe pkgs.chromium} --app=http://beta.wootility.io %U";
    terminal = false;
    icon = "${./wootility-web.png}";
  };
}
