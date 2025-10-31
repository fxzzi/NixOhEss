{
  pkgs,
  lib,
  ...
}: {
  # the M27Q is a bgr monitor
  fonts.fontconfig.subpixel.rgba = "bgr";
  hardware.display = {
    edid = {
      enable = true;
      packages = [
        # EDID pulled from my M27Q, refresh rate increased, 170 -> 175Hz, with VRR range lowered to 36Hz
        (pkgs.runCommand "M27Q-EDID" {} ''
          mkdir -p "$out/lib/firmware/edid"
          base64 -d > "$out/lib/firmware/edid/M27Q.bin" <<'EOF'
          AP///////wAcVA0nAQEBAf8eAQS1PCJ4+8uFp1M1tiUNUFQAAADRwAEBAQEBAYGAlQCzAAEBVl4A
          oKCgKVAwIDUAVE8hAAAeAAAA/QAgr/PzSAEKICAgICAgAAAA/ABNMjdRCiAgICAgICAgAAAA/wAy
          MDEyMEIwMDAwMDEKAiACAy9xSQIDERIEL5A/BSMJFweDAQAAbRoAAAIBMKoAAAAAAADjBeMB5gYF
          AWRkHg7JgFBwoB9QCjw1AFRPIQAAHvW9AGSgoFVQEiD4DFRPIQAAHtWJgMhwOE1ARCD4DFRPIQAA
          HgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUnASeQAAAwEUYxMBgP8JnwAvgB8AnwUnABkABwAD
          ARRf6AAA/wl3ABsAHwCfBWYACAAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANWQ
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
  # sh*tty nvidia makes the tty on my 1440p monitor 1080p
  # so just resize it to 1440p
  systemd.services.fbset = {
    enable = true;
    wantedBy = ["multi-user.target"];
    unitConfig = {
      Description = "Set framebuffer resolution";
      Before = "display-manager.service";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe pkgs.fbset} -xres 2560 -yres 1440 -match --all";
      RemainAfterExit = "yes";
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
