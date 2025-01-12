{
  pkgs,
  config,
  lib,
  ...
}: {
  options.apps.browsers.librewolf.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the librewolf browser.";
  };
  config = lib.mkIf config.apps.browsers.librewolf.enable {
    home.packages = with pkgs; [pywalfox-native];
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

    /*
    We can't use programs.librewolf.settings here because
    of the special `newTabURL` override i have, which
    home-manager fails to set properly.
    the home-manager setup is pretty basic anyway, so this
    should suffice
    */
    home.file.".librewolf/librewolf.overrides.cfg".text = lib.mkIf config.programs.librewolf.enable ''
      // Set new tab page to local startpage
      let { utils:Cu } = Components;

      Cu.import("resource:///modules/AboutNewTab.jsm");
      let newTabURL = "file://${config.home.homeDirectory}/.local/packages/startpage/fazzi/index.html";
      AboutNewTab.newTabURL = newTabURL;

      // Revert some security changes
      pref("webgl.disabled", false);
      pref("privacy.resistFingerprinting", false);
      pref("privacy.clearOnShutdown.history", false);
      pref("privacy.clearOnShutdown.cookies", false);

      // Stop weirdness when relaunching browser sometimes
      pref("browser.sessionstore.resume_from_crash", false);

      // Enable NVIDIA VA-API driver
      pref("media.ffmpeg.vaapi.enabled", true);
      pref("widget.dmabuf.force-enabled", true);

      // Mouse behavior
      pref("middlemouse.paste", false);
      pref("general.autoScroll", true);

      // Performance
      pref("layout.frame_rate", -1);

      // Smooth scrolling
      pref("general.smoothScroll", false);

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
    '';
  };
}
