{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cfg.programs.librewolf;
  librewolf = pkgs.librewolf.override {
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
    nixpkgs.config.permittedInsecurePackages = with librewolf; [
      "${pname}-${version}"
      "${pname}-unwrapped-${version}"
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
