{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe';
  cfg = config.cfg.programs.adb;
in {
  options.cfg.programs.adb.enable = mkEnableOption "adb";
  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.${config.cfg.core.username} = {
      extraGroups = ["adbusers"];
    };
    hj = {
      packages = with pkgs; [
        scrcpy
        payload-dumper-go
      ];
    };
    environment = {
      sessionVariables = {
        ANDROID_HOME = "$HOME/.local/share/android"; # Android SDK home
      };
      shellAliases = {
        adb = "HOME=$ANDROID_HOME ${getExe' pkgs.android-tools "adb"}";

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
