{
  pkgs,
  config,
  lib,
  osConfig,
  inputs,
  ...
}: let
  newTabPage = "file://${config.xdg.dataHome}/startpage/${config.cfg.apps.browsers.startpage.user}/index.html";
in {
  options.cfg.apps.browsers.librewolf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the librewolf browser.";
    };
  };
  config = lib.mkIf config.cfg.apps.browsers.librewolf.enable {
    xdg.dataFile."startpage" = lib.mkIf config.cfg.apps.browsers.startpage.enable {
      source = inputs.startpage; # startpage
    };
    home = {
      packages = with pkgs; [pywalfox-native];
      /*
      We can't use programs.librewolf.settings here because
      of the special `newTabURL` override i have, which
      home-manager fails to set properly.
      the home-manager setup is pretty basic anyway, so this
      should suffice
      */
      file.".librewolf/librewolf.overrides.cfg".text =
        lib.mkIf config.programs.librewolf.enable
        #js
        ''
          ${lib.optionalString config.cfg.apps.browsers.startpage.enable
            #js
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

          ${lib.optionalString osConfig.cfg.gpu.nvidia.enable
            #js
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

      sessionVariables = lib.mkIf osConfig.cfg.gpu.nvidia.enable {
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
        MOZ_DISABLE_RDD_SANDBOX = "1";
      };
    };
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf.overrideAttrs (_old: {
        nativeMessagingHosts = with pkgs; [pywalfox-native];
      });
      languagePacks = [
        "en-GB"
        "en-US"
      ];
    };
    xdg.mimeApps.defaultApplications = {
      "application/xhtml+xml" = "librewolf.desktop";
      "text/html" = "librewolf.desktop";
      "text/xml" = "librewolf.desktop";
      "x-scheme-handler/ftp" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
    };
  };
}
