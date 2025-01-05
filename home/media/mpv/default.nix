{ pkgs, ... }:
{
	programs.mpv = {
		enable = true;
		config = {
			save-position-on-quit = true;
			force-seekable = true;

			demuxer-max-back-bytes = "20M";
			demuxer-max-bytes = "20M";

			vlang = "en,eng";
			vo = "gpu-next";

			volume-max = 100;
			volume = 75;

			keep-open = true;
			pause = false;

			hwdec = "nvdec";

			alang = "en,eng";
			embeddedfonts = true;
			slang = "en,eng";
			sub-auto = "all";
			sub-color = "#eaea27";
			sub-file-paths-append = [
				"Subs/\${filename/no-ext}"
				"Subs/\${filename}"
				"subs/\${filename/no-ext}"
				"subs/\${filename}"
				"ASS"
				"Ass"
				"SRT"
				"Srt"
				"Sub"
				"Subs"
				"Subtitles"
				"ass"
				"srt"
				"sub"
				"subs"
				"subtitles"
			];
			sub-fix-timing = false;
			sub-font-size = 45;
			sub-font = "Noto Sans";
			sub-scale-with-window = true;

			cursor-autohide = 100;
			cursor-autohide-fs-only = true;
			msg-color = true;
			msg-module = true;
			term-osd-bar = true;
		};
		bindings = {
			"MOUSE_BTN0" = "show-progress";
			"MOUSE_BTN0_DBL" = "cycle fullscreen";
			"MOUSE_BTN2" = "cycle pause";

			"RIGHT" = "osd-msg-bar seek +5 relative+keyframes";
			"LEFT" = "osd-msg-bar seek -5 relative+keyframes";
			"SHIFT+RIGHT" = "osd-msg-bar seek +1 relative+exact";
			"SHIFT+LEFT" = "osd-msg-bar seek -1 relative+exact";
			"CTRL+RIGHT" = "frame-step ; show-text \"Frame: \${estimated-frame-number} / \${estimated-frame-count}\"";
			"CTRL+LEFT" = "frame-back-step ; show-text \"Frame: \${estimated-frame-number} / \${estimated-frame-count}\"";

			"UP" = "osd-msg-bar seek +30 relative+keyframes";
			"DOWN" = "osd-msg-bar seek -30 relative+keyframes";
			"SHIFT+UP" = "osd-msg-bar seek +120 relative+keyframes";
			"SHIFT+DOWN" = "osd-msg-bar seek -120 relative+keyframes";

			"PGUP" = "osd-msg-bar seek +600 relative+keyframes";
			"PGDWN" = "osd-msg-bar seek -600 relative+keyframes";

			"SHIFT+PGUP" = "osd-msg-bar seek +1200 relative+keyframes";
			"SHIFT+PGDWN" = "osd-msg-bar seek +1200 relative+keyframes";

			"-" = "add volume -2 ; show-text \"Volume: \${volume}\"";
			"=" = "add volume +2 ; show-text \"Volume: \${volume}\"";

			"Q" = "quit";
			"u" = "cycle-values hwdec \"nvdec\" \"no\"";

			"i" = "script-binding stats/display-stats";
			"I" = "script-binding stats/display-stats-toggle";
			"o" = "cycle-values osd-level 3 1";
			"p" = "cycle-values video-rotate 90 180 270 0";
			"P" = "cycle-values video-aspect \"16:9\" \"4:3\" \"2.35:1\" \"16:10\"";

			"a" = "cycle audio";

			"s" = "cycle sub";
			"S" = "cycle sub-visibility";
			"CTRL+s" = "cycle secondary-sid";

			"l" = "cycle-values loop-file yes no ; show-text \"\${?=loop-file==inf:Looping enabled (file)}\${?=loop-file==no:Looping disabled (file)}\"";

			"ESC" = "cycle fullscreen";
			"SPACE" = "cycle pause";
			"m" = "cycle mute";
		};
		scripts = with pkgs.mpvScripts; [
			mpv-discord
		];
	};
}
