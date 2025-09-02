{pkgs}: let
  inherit (pkgs) callPackage;
in rec {
  audio = callPackage ./audio.nix {};
  brightness-laptop = callPackage ./brightness-laptop.nix {};
  brightness = callPackage ./brightness.nix {};
  cycle-wall = callPackage ./cycle-wall.nix {inherit wallust-script;};
  mpd-notif = callPackage ./mpd-notif.nix {};
  random-wall = callPackage ./random-wall.nix {inherit wallust-script;};
  screenshot = callPackage ./screenshot.nix {};
  sunset = callPackage ./sunset.nix {};
  transcode = callPackage ./transcode.nix {};
  wall-picker = callPackage ./wall-picker.nix {inherit wallust-script;};
  wallust-script = callPackage ./wallust.nix {};
}
