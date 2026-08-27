{ pkgs, ... }: {
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        deluge
        stremio-linux-shell
      ];
    };
    boot.loader.limine.secureBoot.enable = true;
    # allow updating the timezone manually when travelling
    services.tzupdate.enable = true;
  };
}
