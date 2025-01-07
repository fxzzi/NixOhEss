{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.apps.browsers.chromium.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables chromium.";
  };
  options.apps.browsers.chromium.wootility.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the wootility desktop app through chromium.";
  };
	config = lib.mkIf config.apps.browsers.chromium.enable {
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
		xdg.desktopEntries."wootility" = lib.mkIf config.apps.browsers.chromium.wootility.enable {
			name = "Wootility Web";
			exec = "${lib.getExe pkgs.chromium} --app=http://beta.wootility.io %U";
			terminal = false;
			icon = "${./wootility-web.png}";
		};
	};
}
