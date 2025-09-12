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
        # EDID pulled from my M27Q, refresh rate increased, 170 > 176Hz, with VRR range lowered to 32Hz
        (pkgs.runCommand "M27Q-EDID" {} ''
          mkdir -p "$out/lib/firmware/edid"
          base64 -d > "$out/lib/firmware/edid/M27Q.bin" <<'EOF'
          AP///////wAcVA0nAQEBARQeAQS1PCJ4+8uFp1M1tiUNUFQAAAABAQEBAQEBAQEBAQEBAQEB//8A
          aKCgKFAYIKgEgGghAAAaAAAA/QAwsPPzYwEKICAgICAgAAAA/ABNMjdRCiAgICAgICAgAAAA/wAy
          MDEyMEIwMDAwMDEKAgACAy9ASQIDERIEL5A/BSMJFweDAQAAbRoAAAIBILAAAAAAAADjBeMB5gYF
          AWRkHk6ZgMhwOE1ARCD4DOAOEQAAHrvNgGhwoChQGCCoBOBoEQAAGgAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEHASeQAAAwEUyA4BgP8JZwAXgB8AnwUnABkABwAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPaQ
          EOF
        '')
      ];
    };
    outputs = {
      "DP-2" = {
        edid = "M27Q.bin";
        mode = "2560x1440@176";
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
