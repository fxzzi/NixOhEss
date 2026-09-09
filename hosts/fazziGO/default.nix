{ pkgs, ... }: {
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        deluge
        stremio-linux-shell
        cemu
      ];
    };
    boot.loader.limine.secureBoot.enable = true;
    time.timeZone = "Asia/Karachi";
  };
}
