{
  config,
  newTabPage,
  ...
}: {
  # Set home page
  "browser.startup.homepage" =
    if config.cfg.programs.startpage.enable
    then newTabPage
    else "about:home";

  # don't firefox sync the homepage, stops it overwriting on windows.
  "services.sync.prefs.sync.browser.startup.homepage" = !config.cfg.programs.startpage.enable;

  # Revert some security changes
  "webgl.disabled" = false;
  "privacy.resistFingerprinting" = false;
  "privacy.clearOnShutdown.history" = false;
  "privacy.clearOnShutdown.cookies" = false;

  # Stop weirdness when relaunching browser sometimes
  "browser.sessionstore.resume_from_crash" = false;
  "browser.startup.couldRestoreSession.count" = 0;

  # Don't hide http or https in URL bar
  "browser.urlbar.trimURLs" = false;

  # Show full URL on search results pages
  "browser.urlbar.showSearchTerms.enabled" = false;

  # Force hardware acceleration (NVIDIA)
  "media.hardware-video-decoding.force-enabled" = true;

  # Mouse behavior
  "middlemouse.paste" = false;
  "general.autoScroll" = true;

  # Disable touchpad overscroll
  "apz.overscroll.enabled" = false;

  # Don't limit frame rate
  "layout.frame_rate" = -1;

  # Disable smooth scrolling
  "general.smoothScroll" = config.cfg.programs.smoothScroll.enable;

  # Enable Firefox accounts
  "identity.fxaccounts.enabled" = true;

  # Use system emoji fonts
  "font.name-list.emoji" = "emoji";
  "gfx.font_rendering.opentype_svg.enabled" = false;

  # Disable audio post processing
  "media.getusermedia.audio.processing.aec" = 0;
  "media.getusermedia.audio.processing.aec.enabled" = false;
  "media.getusermedia.audio.processing.agc" = 0;
  "media.getusermedia.audio.processing.agc.enabled" = false;
  "media.getusermedia.audio.processing.agc2.forced" = false;
  "media.getusermedia.audio.processing.noise" = 0;
  "media.getusermedia.audio.processing.noise.enabled" = false;
  "media.getusermedia.audio.processing.hpf.enabled" = false;

  # Disable speech dispatcher stuff
  "reader.parse-on-load.enabled" = false;
  "media.webspeech.synth.enabled" = false;

  # Disable bookmarks bar
  "browser.toolbars.bookmarks.visibility" = "never";

  # use sans serif over serif
  "font.default.x-western" = "sans-serif";

  # Hide X button (not needed in tiling WMs)
  "browser.tabs.inTitlebar" = 0;

  # enable compact ui
  "browser.compactmode.show" = true;
  "browser.uidensity" = 1;

  # allow theming
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
}
