{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types concatMapAttrsStringSep optionalString;
  inherit (builtins) toJSON isBool isInt isString toString;
  prefs = {
    # Set home page
    "browser.startup.homepage" =
      if config.cfg.programs.startpage.enable
      then config.cfg.programs.startpage.page
      else "about:home";

    # don't firefox sync the homepage, stops it overwriting on windows.
    "services.sync.prefs.sync.browser.startup.homepage" = !config.cfg.programs.startpage.enable;

    # Revert some security changes
    "webgl.disabled" = false;
    # webgl isn't too big of an attack vector nowadays
    "librewolf.webgl.prompt" = false;
    "privacy.resistFingerprinting" = false;
    "privacy.clearOnShutdown.history" = false;
    "privacy.clearOnShutdown.cookies" = false;

    # Stop weirdness when relaunching browser sometimes
    "browser.sessionstore.resume_from_crash" = false;
    "browser.startup.couldRestoreSession.count" = 0;

    # Force hardware acceleration (NVIDIA)
    "media.hardware-video-decoding.force-enabled" = true;

    # Mouse behavior
    "middlemouse.paste" = false;
    "general.autoScroll" = true;

    # Disable touchpad overscroll
    "apz.overscroll.enabled" = false;

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

    # by default ff hides "http(s)://" in the URL bar. why??
    "browser.urlbar.trimURLs" = false;
  };
  attrsToLines = f: attrs: concatMapAttrsStringSep "\n" f attrs;
  prefValue = pref:
    toJSON (
      if isBool pref || isInt pref || isString pref
      then pref
      else toString pref
    );
  # lockPref here means the options will show grayed out in ff.
  jsPrefs = attrsToLines (name: value: "lockPref(\"${name}\", ${prefValue value});") prefs;
in {
  # internal option so we can apply these prefs in the other file
  options.cfg.programs.librewolf.prefs = mkOption {
    type = types.str;
    internal = true;
  };

  config.cfg.programs.librewolf.prefs = ''
    ${optionalString config.cfg.programs.startpage.enable ''
      // sets the new tab page to our local newtab.
      ChromeUtils.importESModule("resource:///modules/AboutNewTab.sys.mjs").AboutNewTab.newTabURL = "${config.cfg.programs.startpage.page}";
    ''}
    ${jsPrefs}
  '';
}
