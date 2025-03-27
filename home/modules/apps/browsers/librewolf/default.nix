{
  pkgs,
  config,
  lib,
  osConfig,
  inputs,
  ...
}: let
  newTabPage = "file://${config.xdg.dataHome}/startpage/fazzi/index.html";
in {
  options.cfg.apps.browsers.librewolf.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the librewolf browser.";
  };
  config = lib.mkIf config.cfg.apps.browsers.librewolf.enable {
    xdg.dataFile."startpage".source = inputs.startpage; # startpage
    home = {
      packages = with pkgs; [pywalfox-native];
      /*
      We can't use programs.librewolf.settings here because
      of the special `newTabURL` override i have, which
      home-manager fails to set properly.
      the home-manager setup is pretty basic anyway, so this
      should suffice
      */
      file.".librewolf/librewolf.overrides.cfg".text = lib.mkIf config.programs.librewolf.enable ''
        // Set new tab page to local startpage
        let { utils:Cu } = Components;
        Cu.import("resource:///modules/AboutNewTab.jsm");
        AboutNewTab.newTabURL = "${newTabPage}";

        pref("browser.startup.homepage", "${newTabPage}");
        pref("services.sync.prefs.sync.browser.startup.homepage", false);

      '';
      sessionVariables = lib.mkIf osConfig.cfg.gpu.nvidia.enable {
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
        MOZ_DISABLE_RDD_SANDBOX = "1";
      };
    };
    programs.librewolf = {
      enable = true;
      # package = pkgs.librewolf.overrideAttrs (_old: {
      #   extraNativeMessagingHosts = with pkgs; [pywalfox-native];
      # });
      package = inputs.nixpkgs-old.legacyPackages.${pkgs.system}.librewolf;
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
