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
          force-seekable=yes
          demuxer-max-back-bytes=20M
          demuxer-max-bytes=20M
          vlang=en,eng
          vo=gpu-next
          volume-max=150 # allow some overamp
          volume=100
          keep-open=yes
          pause=no
          hwdec=auto
          alang=en,eng
          embeddedfonts=no # just use system fonts
          slang=en,eng
          sub-auto=all
          sub-color="#B9C1D6"
          sub-file-paths-append=Subs/''${filename/no-ext}
          sub-file-paths-append=Subs/''${filename}
          sub-file-paths-append=subs/''${filename/no-ext}
          sub-file-paths-append=subs/''${filename}
          sub-file-paths-append=ASS
          sub-file-paths-append=Ass
          sub-file-paths-append=SRT
          sub-file-paths-append=Srt
          sub-file-paths-append=Sub
          sub-file-paths-append=Subs
          sub-file-paths-append=Subtitles
          sub-file-paths-append=ass
          sub-file-paths-append=srt
          sub-file-paths-append=sub
          sub-file-paths-append=subs
          sub-file-paths-append=subtitles
          sub-fix-timing=no
          sub-font-size=36
          sub-font=${head config.fonts.fontconfig.defaultFonts.sansSerif}
          sub-scale-with-window=yes
          cursor-autohide=250
          cursor-autohide-fs-only=yes
          msg-color=yes
          msg-module=yes
          term-osd-bar=yes
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
