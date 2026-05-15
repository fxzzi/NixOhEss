{
  pkgs,
  pins,
  inputs,
  lib,
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
    xdg.config.files."hypr/hyprland.lua".text =
      lib.mkAfter
      # lua
      ''
        hl.monitor({
        	output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 23080B004543",
        	mode = "2560x1440@170",
        	-- bad hdr
        	supports_hdr = -1,
        	-- this monitor does support 10bit, but only at 120Hz and lower.
        	supports_wide_color = -1,
        })
      '';
  };
  cfg.programs.hyprland.config = {
    render = {
      # sidestep all cm issues by just disabling it
      cm_enabled = 0;
      # same with ds
      direct_scanout = 0;
    };
    # same with tearing
    general = {
      allow_tearing = 0;
    };
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
