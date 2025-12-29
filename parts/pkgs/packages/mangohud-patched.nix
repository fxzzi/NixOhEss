{
  pkgs,
  fetchpatch,
}: let
  patches = [
    (fetchpatch {
      url = "https://github.com/flightlessmango/MangoHud/pull/1924.patch";
      sha256 = "sha256-yI3S/pjQb358/evE1ageO0zdJ0E7aQO87CA1Rd2FOjo=";
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
