{stdenvNoCC, ...}:
stdenvNoCC.mkDerivation {
  pname = "xcursor-pro-light-hyprcursor";
  cursorTheme = "xcursor-pro";
  version = "1.0";

  src = builtins.fetchTarball {
    url = "https://github.com/4lrick/XCursor-Pro-Hyprcursor/releases/download/V1.0/XCursor-Pro-Light-Hyprcursor.tar.xz";
    sha256 = "05ckr0l47p1kg9zaavy88nhzx3cg2k3q2gj329bywdp6hs25r6f3";
  };

  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/share/icons/"$cursorTheme"/hyprcursors

    cp -a $src/hyprcursors/* $out/share/icons/"$cursorTheme"/hyprcursors/
    install -m644 $src/manifest.hl $out/share/icons/"$cursorTheme"/manifest.hl
  '';
}
