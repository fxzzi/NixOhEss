{
  nixpkgs.overlays = [
    (final: prev: let
      inherit (prev) callPackage;
    in {
      customPkgs = {
        audio = callPackage ./audio.nix {};
        brightness-laptop = callPackage ./brightness-laptop.nix {};
        brightness = callPackage ./brightness.nix {};
        cudaBoostBypass = callPackage ./cudaBoostBypass.nix {};
        cycle-wall = callPackage ./cycle-wall.nix {inherit (final.customPkgs) wallust-script;};
        eden = callPackage ./eden.nix {};
        egl-wayland2 = callPackage ./egl-wayland2.nix {};
        flac2opus = callPackage ./flac2opus.nix {};
        flac2vorbis = callPackage ./flac2vorbis.nix {};
        ioshelfka-term = callPackage ./ioshelfka-term.nix {};
        mpd-notif = callPackage ./mpd-notif.nix {};
        random-wall = callPackage ./random-wall.nix {inherit (final.customPkgs) wallust-script;};
        screenshot = callPackage ./screenshot.nix {};
        sunset = callPackage ./sunset.nix {};
        transcode = callPackage ./transcode.nix {};
        wall-picker = callPackage ./wall-picker.nix {inherit (final.customPkgs) wallust-script;};
        wallust-script = callPackage ./wallust.nix {};
        stremio-enhanced = callPackage ./stremio-enhanced.nix {};
        stremio-linux-shell = callPackage ./stremio-linux-shell.nix {};
        stremio-linux-shell-cef = callPackage ./stremio-linux-shell-cef.nix {};
      };
    })
  ];
}
