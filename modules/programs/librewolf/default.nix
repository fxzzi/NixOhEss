{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf concatMapAttrsStringSep;
  inherit (builtins) toJSON isBool isInt isString toString;
  cfg = config.cfg.programs.librewolf;
  newTabPage = "file:///home/${config.cfg.core.username}/.local/share/startpage/${config.cfg.programs.startpage.user}/index.html";
  attrsToLines = f: attrs: concatMapAttrsStringSep "\n" f attrs;
  # thank you diniamo for this cool pref setup!
  # https://github.com/diniamo/niqs/blob/main/modules/workstation/librewolf/default.nix
  prefs = import ./prefs.nix {inherit newTabPage config;};
  prefValue = pref:
    toJSON (
      if isBool pref || isInt pref || isString pref
      then pref
      else toString pref
    );
  jsPrefs = attrsToLines (name: value: "lockPref(\"${name}\", ${prefValue value});") prefs;
in {
  options.cfg.programs.librewolf = {
    enable = mkEnableOption "librewolf";
  };
  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        pywalfox-native
        (librewolf.override {
          extraPrefs = jsPrefs;
          # nativeMessagingHosts = mkIf config.cfg.programs.wallust.enable [pkgs.pywalfox-native];
        })
      ];
      xdg.config.files."librewolf/librewolf.overrides.cfg" = mkIf config.cfg.programs.startpage.enable {
        text = ''
          // sets the new tab page to our local newtab.
          ChromeUtils.importESModule("resource:///modules/AboutNewTab.sys.mjs").AboutNewTab.newTabURL = "${newTabPage}";
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
