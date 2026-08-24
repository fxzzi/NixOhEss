{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.adb;
in
{
  options.cfg.programs.adb.enable = mkEnableOption "adb";
  config = mkIf cfg.enable {
    users.users.${config.cfg.core.username} = {
      extraGroups = [ "adbusers" ];
    };
    hj = {
      packages = with pkgs; [
        android-tools
        (symlinkJoin {
          name = "scrcpy";
          paths = [ scrcpy ];
          postBuild = ''
            unlink $out/share/applications/scrcpy.desktop
            unlink $out/share/applications/scrcpy-console.desktop
          '';
        })
      ];
    };
    environment = {
      shellAliases = {
        webcam1080 = ''
          scrcpy --video-source=camera --no-audio --camera-facing=back \
          --v4l2-sink=/dev/video0 --camera-size=1920x1080 --video-bit-rate=6000K \
          --video-codec=h265 --render-driver=opengl --camera-fps=60 --angle=0 \
          --no-window
        '';
        webcamfull = ''
          scrcpy --video-source=camera --no-audio --camera-facing=back \
          --v4l2-sink=/dev/video0 --camera-size=1920x1440 --video-bit-rate=8000K \
          --video-codec=h265 --render-driver=opengl --camera-fps=60 --angle=0 \
          --no-window'';
        webcamfull1080 = ''
          scrcpy --video-source=camera --no-audio --camera-facing=back \
          --v4l2-sink=/dev/video0 --camera-size=1440x1080 --video-bit-rate=6000K \
          --video-codec=h265 --render-driver=opengl --camera-fps=60 --angle=0 \
          --no-window
        '';
      };
    };
  };
}
