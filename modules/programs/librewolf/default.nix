{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf concatMapAttrsStringSep optionalString;
  inherit (builtins) toJSON isBool isInt isString toString;
  cfg = config.cfg.programs.librewolf;
  newTabPage = "file:///home/${config.cfg.core.username}/.local/share/startpage/${config.cfg.programs.startpage.user}/index.html";
  attrsToLines = f: attrs: concatMapAttrsStringSep "\n" f attrs;
  # thank you diniamo for this cool pref setup!
  # https://github.com/diniamo/niqs/blob/main/modules/workstation/librewolf/default.nix
  # NOTE: this file begins with an _ so that my recursive importer in `../../default.nix` ignores it.
  prefs = import ./_prefs.nix {inherit newTabPage config;};
  prefValue = pref:
    toJSON (
      if isBool pref || isInt pref || isString pref
      then pref
      else toString pref
    );
  jsPrefs = attrsToLines (name: value: "lockPref(\"${name}\", ${prefValue value});") prefs;
  newTabPageJS = ''
    // sets the new tab page to our local newtab.
    ChromeUtils.importESModule("resource:///modules/AboutNewTab.sys.mjs").AboutNewTab.newTabURL = "${newTabPage}";
  '';
  librewolf = pkgs.librewolf-bin.override {
    extraPrefs = ''
      ${optionalString config.cfg.programs.startpage.enable newTabPageJS}
      ${jsPrefs}
    '';
    extraPolicies = {
      SearchEngines = {
        PreventInstalls = true;
        Add = [
          {
            Name = "Google";
          }
        ];
        Remove = [
          "DuckDuckGo"
          "Wikipedia (en)"
          "Bing"
        ];
        Default = "Google";
      };
      SearchSuggestEnabled = false;
    };
  };
in {
  options.cfg.programs.librewolf = {
    enable = mkEnableOption "librewolf";
  };
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.pywalfox-native
        librewolf
      ];
    };
    # some schmuck marked librewolf bin packages as insecure
    nixpkgs.config.permittedInsecurePackages = [
      "librewolf-bin-unwrapped-${librewolf.version}"
      "librewolf-bin-${librewolf.version}"
    ];
    environment.sessionVariables = mkIf config.cfg.hardware.nvidia.enable {
      LIBVA_DRIVER_NAME = "nvidia";
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
