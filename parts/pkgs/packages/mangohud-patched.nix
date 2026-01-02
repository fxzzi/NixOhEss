{
  pkgs,
  fetchpatch,
}: let
  patches = [
    # fix oversaturated colors in HDR, and undersaturated colors in CS2, Haste (SDL?)
    (fetchpatch {
      url = "https://github.com/flightlessmango/MangoHud/pull/1924.patch";
      sha256 = "sha256-yI3S/pjQb358/evE1ageO0zdJ0E7aQO87CA1Rd2FOjo=";
    })
    # allow customizing the font size of units like Mhz, etc
    (fetchpatch {
      url = "https://github.com/flightlessmango/MangoHud/pull/1811.patch";
      sha256 = "sha256-0mnTTzyu3IN8RwCzSe6PLniW7CXJZpn+CEkKR4iGbWI=";
    })
    # prioritize better sensors for cpu temp
    (fetchpatch {
      url = "https://github.com/flightlessmango/MangoHud/pull/1930.patch";
      sha256 = "sha256-Cq4SwAas3DkhQksKbeLzRbvJfEhz+xlkRr1f+rOfL14=";
    })
  ];
in
  (pkgs.mangohud.overrideAttrs (old: {
    patches = (old.patches or []) ++ patches;
  })).override {
    mangohud32 = pkgs.pkgsi686Linux.mangohud.overrideAttrs (old: {
      patches = (old.patches or []) ++ patches;
    });
  }
