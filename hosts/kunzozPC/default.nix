{
  pkgs,
  pins,
  ...
}: {
  system.stateVersion = "25.05";
  hj = {
    packages = with pkgs; [
      losslesscut-bin
      qbittorrent
      nvtopPackages.amd
      sgdboop
      cemu
      # stremio-linux-shell
      losange
      (callPackage "${pins.creamlinux}" {})
    ];
  };

  hardware.display.outputs."DP-3".mode = "2560x1440@170";

  networking.firewall = {
    # minecraft
    allowedUDPPorts = [25565];
    allowedTCPPorts = [25565];
  };
}
