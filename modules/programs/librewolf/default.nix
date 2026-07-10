{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cfg.programs.librewolf;
  librewolf = pkgs.librewolf-bin.override {
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
    # librewolf re-enabled the sandbox recently, which broke my new tab override setup.
    # this jank solution below is able to re-disable it again. maybe don't do this???
    nixpkgs.overlays = [
      (_: prev: {
        librewolf-bin-unwrapped = prev.librewolf-bin-unwrapped.overrideAttrs (old: {
          postInstall =
            (old.postInstall or "")
            + ''
              echo 'pref("general.config.sandbox_enabled", false);' \
                >> "$out/lib/librewolf-bin-${prev.librewolf-bin-unwrapped.version}/defaults/pref/local-settings.js"
            '';
        });
      })
    ];

    hj.packages = [librewolf];

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
