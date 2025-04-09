{
  stdenvNoCC,
  config,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "posy-cursors-hyprcursor";
  cursorTheme = config.home.pointerCursor.name;
  version = "1.2";

  src = builtins.fetchurl {
    url = "https://github.com/Morxemplum/posys-cursor-scalable/releases/download/v1.2/posys-cursor-scalable-v1.2.tar.gz";
    sha256 = "0bpqapj27v2d341pfcsd83px5d2cxm54b48972k0ym42h0b7zqnk";
  };

  phases = ["unpackPhase" "installPhase"];

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
