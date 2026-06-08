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
        (retroarch.withCores (cores:
          with cores; [
            bsnes
          ]))
      ];
    };
    boot.loader.limine.secureBoot.enable = true;
    # set timezone automatically for travelling
    services.automatic-timezoned.enable = true;
  };
}
