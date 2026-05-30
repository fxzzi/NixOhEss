{
  pkgs,
  pins,
  inputs,
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
      inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.losange
      (callPackage "${pins.creamlinux}" {})
    ];
  };
  hardware.display = {
    outputs = {
      "DP-3".mode = "2560x1440@170";
    };
  };
  networking.firewall = {
    # minecraft
    allowedUDPPorts = [25565];
    allowedTCPPorts = [25565];
  };
}
