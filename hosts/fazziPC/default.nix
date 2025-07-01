{pkgs, ...}: {
  system.stateVersion = "25.05";
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "16G";
    MemoryMax = "24G";
  };
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
    allowedUDPPorts = [25565];
    allowedTCPPorts = [25565];
  };
  hardware.display = {
    edid = {
      enable = true;
      packages = [
        # EDID pulled from my M27Q, refresh rate increased, 170 > 174Hz, with VRR range lowered to 32Hz
        (pkgs.runCommand "M27Q-EDID" {} ''
          mkdir -p "$out/lib/firmware/edid"
          base64 -d > "$out/lib/firmware/edid/M27Q.bin" <<'EOF'
          AP///////wAcVA0nAQEBARQeAQS1Rid4+8uFp1M1tiUNUFQvzwDRwAEBAQEBAYGAlQCzAAEBVl4A
          oKCgKVAwIDUAVE8hAAAeAAAA/QAgr/PzPAEKICAgICAgAAAA/ABNMjdRCiAgICAgICAgAAAA/wAy
          MDEyMEIwMDAwMDEKAgoCAy9xSQIDERIEL5A/BSMJFweDAQAAbRoAAAIBMKoAAAAAAADjBeMB5gYF
          AWRkHgD6AFCgoB9QCjw1AFRPIQAAHvW9AGSgoFVQEiD4DFRPIQAAHtWJgMhwOE1ARCD4DFRPIQAA
          HgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf3ASeQAAAwEUshEBAP8JnwAvgB8AnwUnABkABwAD
          ARRf6AAA/wl3ABsAHwCfBWYACAAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAiQ
          EOF
        '')
      ];
      linuxhw = {
        # it adds .bin itself
        "PHL" = [
          "Philips"
          "PHL 273V7"
          "27.2"
          "2024"
        ];
      };
    };
    outputs = {
      "DP-2" = {
        edid = "M27Q.bin";
      };
      "DP-3" = {
        edid = "PHL.bin";
      };
    };
  };
  programs.hyprland.settings = {
    cursor = {
      no_hardware_cursors = 0;
      min_refresh_rate = 32;
      no_break_fs_vrr = 1;
    };
  };
}
