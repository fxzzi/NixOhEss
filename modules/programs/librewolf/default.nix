{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cfg.programs.librewolf;
  librewolf = pkgs.librewolf-bin.override {
    # nativeMessagingHosts = [pkgs.ff2mpv-rust];
    extraPrefs = cfg.prefs;
    extraPolicies = {
      SearchSuggestEnabled = false;
      SearchEngines = {
        PreventInstalls = true;
        Add = [
          {Name = "Google";}
        ];
        Remove = [
          "DuckDuckGo"
          "Wikipedia (en)"
          "Bing"
          "Perplexity"
        ];
        Default = "Google";
      };
    };
  };
in {
  options.cfg.programs.librewolf = {
    enable = mkEnableOption "librewolf";
  };
  config = mkIf cfg.enable {
    hj.packages = [librewolf];

    # some schmuck marked librewolf bin packages as insecure
    nixpkgs.config.permittedInsecurePackages = [
      "librewolf-bin-unwrapped-${librewolf.version}"
      "librewolf-bin-${librewolf.version}"
    ];
    environment.sessionVariables = {
      MOZ_DISABLE_RDD_SANDBOX = 1;
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
