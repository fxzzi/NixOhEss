{stdenvNoCC, ...}:
stdenvNoCC.mkDerivation {
  pname = "posy-cursors-hyprcursor";
  cursorTheme = "posy-cursors";
  version = "1.3";

  src = builtins.fetchurl {
    url = "https://github.com/Morxemplum/posys-cursor-scalable/releases/download/v1.3/hyprcursor_white_v1.3.tar.gz";
    sha256 = "11hf93f1dn2w0rjvsl897q2c5q720qf2d7r6v70bsshym1i04ax1";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  # Unpack manually by extracting the tarball
  unpackPhase = ''
    mkdir -p $out
    tar -xzf $src -C $out
  '';

  installPhase = ''
    # Create the appropriate directory for the cursor theme
    mkdir -p $out/share/icons/"$cursorTheme"/hyprcursors

    # Copy the cursor files
    cp -a $out/theme_Posys-Cursor-Scalable/hyprcursors/* $out/share/icons/"$cursorTheme"/hyprcursors/

    # Install the manifest file
    install -m644 $out/theme_Posys-Cursor-Scalable/manifest.hl $out/share/icons/"$cursorTheme"/manifest.hl
  '';
}
