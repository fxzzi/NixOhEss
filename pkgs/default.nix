{
  nixpkgs.overlays = [
    (final: prev:
    let
      inherit (prev) callPackage;
    in
    {
      audio = callPackage ./audio.nix {};
      brightness-laptop = callPackage ./brightness-laptop.nix {};
      brightness = callPackage ./brightness.nix {};
      cudaBoostBypass = callPackage ./cudaBoostBypass.nix {};
      cycle-wall = callPackage ./cycle-wall.nix { inherit (final) wallust-script; };
      mpd-notif = callPackage ./mpd-notif.nix {};
      random-wall = callPackage ./random-wall.nix { inherit (final) wallust-script; };
      screenshot = callPackage ./screenshot.nix {};
      sunset = callPackage ./sunset.nix {};
      transcode = callPackage ./transcode.nix {};
      wall-picker = callPackage ./wall-picker.nix { inherit (final) wallust-script; };
      wallust-script = callPackage ./wallust.nix {};
    })
  ];
}
