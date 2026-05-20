{
  pkgs,
  inputs,
  ...
}: {
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        deluge
        olympus
        inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.losange
        # (jetbrains.idea-oss.override {
        #   vmopts = "-Dawt.toolkit.name=WLToolkit";
        # })
      ];
    };
    cfg.programs.hyprland.config = {
      # tearing kinda useful on 60hz
      general.allow_tearing = 1;
      render = {
        # sidestep all cm issues by just disabling it
        cm_enabled = 0;
      };
    };
    boot.loader.limine.secureBoot.enable = true;
    # set these when travelling
    services = {
      geoclue2.enable = true;
      localtimed.enable = true;
    };
  };
}
