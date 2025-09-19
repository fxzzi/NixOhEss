{config, ...}: {
  nixpkgs.overlays = [
    (final: prev: let
      inherit (prev) callPackage;
    in {
      egl-wayland =
        if config.cfg.hardware.nvidia.enable
        then (callPackage ./egl-wayland2.nix {})
        else prev.egl-wayland;
      customPkgs = {
        audio = callPackage ./audio.nix {};
        brightness-laptop = callPackage ./brightness-laptop.nix {};
        brightness = callPackage ./brightness.nix {};
        cudaBoostBypass = callPackage ./cudaBoostBypass.nix {};
        cycle-wall = callPackage ./cycle-wall.nix {inherit (final.customPkgs) wallust-script;};
        eden = callPackage ./eden.nix {};
        ioshelfka-term = callPackage ./ioshelfka-term.nix {};
        mpd-notif = callPackage ./mpd-notif.nix {};
        random-wall = callPackage ./random-wall.nix {inherit (final.customPkgs) wallust-script;};
        screenshot = callPackage ./screenshot.nix {};
        sunset = callPackage ./sunset.nix {};
        transcode = callPackage ./transcode.nix {};
        wall-picker = callPackage ./wall-picker.nix {inherit (final.customPkgs) wallust-script;};
        wallust-script = callPackage ./wallust.nix {};
        stremio-linux-shell = callPackage ./stremio-linux-shell.nix {};
      };
    })
  ];
}
