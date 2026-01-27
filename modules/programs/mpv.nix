{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (builtins) head;
in {
  options.cfg.programs.mpv.enable = mkEnableOption "mpv";
  config = mkIf config.cfg.programs.mpv.enable {
    hj = {
      packages = [pkgs.mpv];
      xdg.config.files = {
        "mpv/mpv.conf".text = ''
          save-position-on-quit=yes
          target-colorspace-hint-mode=source
          hwdec=auto
          video-sync=display-resample
          volume-max=150
          keep-open=yes
          fs=yes
          alang=en,eng
          slang=en,eng
          sub-scale=0.75
          sub-color="#C9D1D6"
          sub-font=${head config.fonts.fontconfig.defaultFonts.sansSerif}
          sub-scale-with-window=yes
          cursor-autohide=1000
        '';
        "mpv/input.conf".text = ''
          MOUSE_BTN0 show-progress
          MOUSE_BTN0_DBL cycle fullscreen
          MOUSE_BTN2 cycle pause
          RIGHT osd-msg-bar seek +5 relative+keyframes
          LEFT osd-msg-bar seek -5 relative+keyframes
          SHIFT+RIGHT osd-msg-bar seek +1 relative+exact
          SHIFT+LEFT osd-msg-bar seek -1 relative+exact
          CTRL+RIGHT frame-step ; show-text "Frame: ''${estimated-frame-number} / ''${estimated-frame-count}"
          CTRL+LEFT frame-back-step ; show-text "Frame: ''${estimated-frame-number} / ''${estimated-frame-count}"
          UP osd-msg-bar seek +30 relative+keyframes
          DOWN osd-msg-bar seek -30 relative+keyframes
          SHIFT+UP osd-msg-bar seek +120 relative+keyframes
          SHIFT+DOWN osd-msg-bar seek -120 relative+keyframes
          PGUP osd-msg-bar seek +600 relative+keyframes
          PGDWN osd-msg-bar seek -600 relative+keyframes
          SHIFT+PGUP osd-msg-bar seek +1200 relative+keyframes
          SHIFT+PGDWN osd-msg-bar seek +1200 relative+keyframes
          - add volume -2 ; show-text "Volume: ''${volume}"
          = add volume +2 ; show-text "Volume: ''${volume}"
          Q quit
          i script-binding stats/display-stats
          I script-binding stats/display-stats-toggle
          o cycle-values osd-level 3 1
          p cycle-values video-rotate 90 180 270 0
          a cycle audio
          s cycle sub
          S cycle sub-visibility
          CTRL+s cycle secondary-sid
          l cycle-values loop-file yes no ; show-text "''${?=loop-file==inf:Looping enabled (file)}''${?=loop-file==no:Looping disabled (file)}"
          ESC cycle fullscreen
          SPACE cycle pause
          m cycle mute
        '';
        # When mpv stops at the end of a file, replay from beginning when user tries to resume
        # https://github.com/mpv-player/mpv/issues/11183#issuecomment-1398635235
        "mpv/scripts/replay-at-end.lua".text =
          #lua
          ''
            mp.observe_property("pause", "bool", function(name, value)
                if value == true and mp.get_property("eof-reached") == "yes" then
                    mp.command("no-osd seek 0 absolute")
                end
            end)
          '';
      };
    };
    xdg.mime.defaultApplications = {
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop"; # MKV
      "video/webm" = "mpv.desktop";
      "video/ogg" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop"; # MP3
      "audio/ogg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/aac" = "mpv.desktop";
    };
  };
}
