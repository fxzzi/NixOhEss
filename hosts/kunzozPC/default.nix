{
  pkgs,
  inputs,
  ...
}:
{
  system.stateVersion = "25.05";
  hj = {
    packages = with pkgs; [
      losslesscut
      qbittorrent
      nvtopPackages.amd
      sgdboop
      cemu
      stremio-linux-shell
      (pkgs.callPackage inputs.creamlinux { })
    ];
  };
  hardware.display = {
    edid = {
      enable = true;
      packages = [
        # the M27Q has a broken EDID.
        # so I edited it with a few changes:
        # - Physical size changed to 60x34cm
        # - Removed 10/12-bit, because it was using FRC
        # - Removed the 3840x2160 downscaling mode, because why is this here
        (pkgs.runCommand "M27Q" { } ''
          install -Dm444 ${./M27Q-edid.bin} "$out/lib/firmware/edid/M27Q.bin"
        '')
      ];
    };
    outputs."DP-3" = {
      mode = "2560x1440@170";
      edid = "M27Q.bin";
    };
  };

  networking.firewall = {
    # minecraft
    allowedUDPPorts = [ 25565 ];
    allowedTCPPorts = [ 25565 ];
  };
}
