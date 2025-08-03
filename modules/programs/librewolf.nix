{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionalString;
  cfg = config.cfg.programs.librewolf;
  newTabPage = "file:///home/${config.cfg.core.username}/.local/share/startpage/${config.cfg.programs.startpage.user}/index.html";
in {
  options.cfg.programs.librewolf = {
    enable = mkEnableOption "librewolf";
  };
  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        pywalfox-native
        (librewolf.overrideAttrs {
          nativeMessagingHosts = with pkgs; [pywalfox-native];
        })
      ];
      files = {
        ".librewolf/librewolf.overrides.cfg".text =
          #js
          ''
            ${optionalString config.cfg.programs.startpage.enable #js
              
              ''
                // sets the new tab page to our local newtab.
                ChromeUtils.importESModule("resource:///modules/AboutNewTab.sys.mjs").AboutNewTab.newTabURL = "${newTabPage}";

                // sets our home page to the same URL.
                pref("browser.startup.homepage", "${newTabPage}");

                // don't firefox sync the homepage, stops it overwriting on windows.
                pref("services.sync.prefs.sync.browser.startup.homepage", false);
              ''}

            // Revert some security changes
            pref("webgl.disabled", false);
            pref("privacy.resistFingerprinting", false);
            pref("privacy.clearOnShutdown.history", false);
            pref("privacy.clearOnShutdown.cookies", false);

            // Stop weirdness when relaunching browser sometimes
            pref("browser.sessionstore.resume_from_crash", false);

            // don't hide http or https in url bar
            pref("browser.urlbar.trimURLs", false);

            // show full url on search results pages
            pref("browser.urlbar.showSearchTerms.enabled", false);

            ${optionalString config.cfg.hardware.nvidia.enable #js
              
              ''
                // force hw acceleration
                pref("media.hardware-video-decoding.force-enabled", true);
              ''}

            // Mouse behavior
            pref("middlemouse.paste", false);
            pref("general.autoScroll", true);

            // disable touchpad overscroll
            pref("apz.overscroll.enabled", false);

            // Performance
            pref("layout.frame_rate", -1);

            // Disable smooth scrolling
            pref("general.smoothScroll", ${
              if config.cfg.gui.smoothScroll.enable
              then "true"
              else "false"
            });

            // Enable Firefox accounts
            pref("identity.fxaccounts.enabled", true);

            // Use system emoji fonts
            pref("font.name-list.emoji", "emoji");
            pref("gfx.font_rendering.opentype_svg.enabled", false);

            // Disable audio post processing
            pref("media.getusermedia.audio.processing.aec", 0);
            pref("media.getusermedia.audio.processing.aec.enabled", false);
            pref("media.getusermedia.audio.processing.agc", 0);
            pref("media.getusermedia.audio.processing.agc.enabled", false);
            pref("media.getusermedia.audio.processing.agc2.forced", false);
            pref("media.getusermedia.audio.processing.noise", 0);
            pref("media.getusermedia.audio.processing.noise.enabled", false);
            pref("media.getusermedia.audio.processing.hpf.enabled", false);

            // disable bookmarks bar, i don't use it
            pref("browser.toolbars.bookmarks.visibility", "never");

            // only use fonts defined by system, not by the website
            pref("browser.display.use_document_fonts", 0);

            // hides the X button which is useless on tiling compositors and WMs
            pref("browser.tabs.inTitlebar", 0);
          '';
      };
    };
    environment.sessionVariables = mkIf config.cfg.hardware.nvidia.enable {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
      MOZ_DISABLE_RDD_SANDBOX = "1";
    };
    xdg.mime.defaultApplications = {
      "application/xhtml+xml" = "librewolf.desktop";
      "text/html" = "librewolf.desktop";
      "text/xml" = "librewolf.desktop";
      "x-scheme-handler/ftp" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
    };
  };
}
