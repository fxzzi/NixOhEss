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
  prefs = import ./prefs.nix {inherit newTabPage config;};
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
  baseLibrewolf = pkgs.librewolf-bin.override {
    extraPrefs = ''
      ${optionalString config.cfg.programs.startpage.enable newTabPageJS}
      ${jsPrefs}
    '';
  };
  librewolf =
    if (!config.cfg.hardware.nvidia.enable)
    then baseLibrewolf
    else
      pkgs.symlinkJoin {
        name = "librewolf-bin-cbb";
        paths = [
          baseLibrewolf
        ];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/librewolf \
            --set LD_PRELOAD "${pkgs.cudaBoostBypass}/boost_bypass.so"
        '';
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
