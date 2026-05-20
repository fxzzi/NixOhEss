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
        inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.losange
        # (jetbrains.idea-oss.override {
        #   vmopts = "-Dawt.toolkit.name=WLToolkit";
        # })
      ];
    };
    cfg.programs.hyprland.config = {
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
