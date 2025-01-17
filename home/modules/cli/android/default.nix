{
  pkgs,
  config,
  lib,
  ...
}: {
  options.cli.android.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Adds a few packages like scrcpy and paylod dumper.";
  };
  config =
    lib.mkIf config.cli.android.enable {
      home.packages = with pkgs; [
        scrcpy
        payload-dumper-go
      ];
      programs.zsh.shellAliases = {
        adb = "HOME=${config.xdg.dataHome}/android ${lib.getExe pkgs.android-tools}";

        webcam1080 = "scrcpy --video-source=camera --no-audio --camera-facing=back \\
					--v4l2-sink=/dev/video0 --camera-size=1920x1080 --video-bit-rate=6000K \\
					--video-codec=h265 --render-driver=opengl --camera-fps=60 --angle=0 \\
					--no-window";
        webcamfull = "scrcpy --video-source=camera --no-audio --camera-facing=back \\
					--v4l2-sink=/dev/video0 --camera-size=1920x1440 --video-bit-rate=8000K \\
					--video-codec=h265 --render-driver=opengl --camera-fps=60 --angle=0 \\
					--no-window";
        webcamfull1080 = "scrcpy --video-source=camera --no-audio --camera-facing=back \\
					--v4l2-sink=/dev/video0 --camera-size=1440x1080 --video-bit-rate=6000K \\
					--video-codec=h265 --render-driver=opengl --camera-fps=60 --angle=0 \\
					--no-window";
      };
    };
}
