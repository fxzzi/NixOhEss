{pkgs, ...}: {
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./fancontrol.nix
    ./gtkBookmarks.nix
  ];
  cfg = import ./options.nix;
  # host specific packages
  hj.packages = with pkgs; [
    qbittorrent-enhanced
    telegram-desktop
    losslesscut-bin
    qpwgraph
  ];
  networking.firewall = {
    # minecraft
    allowedUDPPorts = [25565 25564];
    allowedTCPPorts = [25565 25564];
  };
  hardware.display = {
    edid = {
      enable = true;
      packages = [
        # EDID pulled from my M27Q, refresh rate increased, 170 > 175Hz, with VRR range lowered to 32Hz
        (pkgs.runCommand "M27Q-EDID" {} ''
          mkdir -p "$out/lib/firmware/edid"
          base64 -d > "$out/lib/firmware/edid/M27Q.bin" <<'EOF'
          AP///////wAcVA0nAQEBARQeAQS1Rid4+8uFp1M1tiUNUFQvzwDRwAEBAQEBAYGAlQCzAAEBVl4A
          oKCgKVAwIDUAVE8hAAAeAAAA/QAgsPPzPAEKICAgICAgAAAA/ABNMjdRCiAgICAgICAgAAAA/wAy
          MDEyMEIwMDAwMDEKAgkCAy9xSQIDERIEL5A/BSMJFweDAQAAbRoAAAIBMKoAAAAAAADjBeMB5gYF
          AWRkHgD6AFCgoB9QCjw1AFRPIQAAHvW9AGSgoFVQEiD4DFRPIQAAHtWJgMhwOE1ARCD4DFRPIQAA
          HgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf3ASeQAAAwEU/xIBAP8JnwAvgB8AnwUnABkABwAD
          ARRf6AAA/wl3ABsAHwCfBWYACAAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALqQ
          EOF
        '')
      ];
    };
    outputs = {
      "DP-2" = {
        edid = "M27Q.bin";
        mode = "2560x1440@175";
      };
      "DP-3" = {
        mode = "1920x1080@75";
      };
    };
  };
  programs.hyprland.settings = {
    cursor = {
      no_hardware_cursors = 0;
      min_refresh_rate = 32;
    };
  };
}
