{pkgs, ...}: {
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        deluge
        olympus
        stremio-linux-shell
        # (jetbrains.idea-oss.override {
        #   vmopts = "-Dawt.toolkit.name=WLToolkit";
        # })
      ];
    };
    boot.loader.limine.secureBoot.enable = true;
    # set timezone automatically for travelling
    services.automatic-timezoned.enable = true;
  };
}
