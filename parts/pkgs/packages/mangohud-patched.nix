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
    # disable font AA
    (fetchpatch {
      url = "https://github.com/flightlessmango/MangoHud/commit/bf34ad57fef9be74bc0d8bfcc668851bcf4955b9.patch";
      sha256 = "sha256-kNYbA986DE9u2N9zL4PeHWNZRwr3x8pDdHBeHeO/vSs=";
    })
    # remove font oversampling
    (fetchpatch {
      url = "https://github.com/flightlessmango/MangoHud/commit/f1ffc0c5d46b22c58334d6a866e7174cfa3fcaeb.patch";
      sha256 = "sha256-mt1ON1fxBIbEVRme4eCeZdQpbHwLHpTjWCqD5oK01jA=";
    })
    # recreate font if needed
    (fetchpatch {
      url = "https://github.com/flightlessmango/MangoHud/commit/3013b7387d119907499d05996cf0b27a96dd11b5.patch";
      sha256 = "sha256-NXYVDoQ9XW/zbw7iHt3n99w0RvcG7ifCXvE5c0/lz0E=";
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
