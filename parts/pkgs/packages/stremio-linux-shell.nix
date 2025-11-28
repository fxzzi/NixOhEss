{
  lib,
  stdenv,
  rustPlatform,
  openssl,
  pkg-config,
  gtk3,
  mpv,
  libappindicator,
  cef-binary,
  makeWrapper,
  nodejs,
  fetchurl,
  pins,
  ...
}: let
  # the server isn't reachable with too new cef, so use 138
  cef = cef-binary.overrideAttrs (let
    version = "138.0.17";
    gitRevision = "ac9b751";
    chromiumVersion = "138.0.7204.97";
    srcHash = "sha256-3qgIhen6l/kxttyw0z78nmwox62riVhlmFSGPkUot7g=";
  in {
    inherit version gitRevision chromiumVersion;
    src = fetchurl {
      url = "https://cef-builds.spotifycdn.com/cef_binary_${version}+g${gitRevision}+chromium-${chromiumVersion}_linux64_minimal.tar.bz2";
      hash = srcHash;
    };
  });
  # cef-rs expects a specific directory layout
  # Copied from https://github.com/NixOS/nixpkgs/pull/428206 because im lazy
  cef-path = stdenv.mkDerivation {
    pname = "cef-path";
    inherit (cef) version;
    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out"
      cp -r ${cef}/Release/* $out
      cp -r ${cef}/Resources/* $out
      cp -r ${cef}/include $out
    '';
    postFixup = ''
      strip $out/*.so*
    '';
  };
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "stremio-linux-shell";
    src = pins.${finalAttrs.pname};
    version = "0-unstable-${builtins.substring 0 8 finalAttrs.src.revision}";

    # some of the cargo.lock entries don't have hashes?
    # so have to manually put the hash here
    cargoHash = "sha256-3HJqzkhmKF1J3aHiw3UvgeWzLNnr3tw+/cvMyAKNvAQ=";

    buildInputs = [
      openssl
      gtk3
      mpv
    ];

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ];

    env.CEF_PATH = cef-path;

    postInstall = ''
      mkdir -p $out/share/applications
      mkdir -p $out/share/icons/hicolor/scalable/apps

      mv $out/bin/stremio-linux-shell $out/bin/stremio
      cp $src/data/server.js $out/bin/server.js
      cp $src/data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop
      cp $src/data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg


      wrapProgram $out/bin/stremio \
         --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libappindicator]} \
         --prefix PATH : ${lib.makeBinPath [nodejs]}'';

    meta = {
      mainProgram = "stremio";
      description = "Modern media center that gives you the freedom to watch everything you want";
      homepage = "https://github.com/Stremio/stremio-linux-shell";
      # (Server-side) 4.x versions of the web UI are closed-source
      license = with lib.licenses; [
        gpl3Only
        # server.js is unfree
        unfree
      ];
      maintainers = lib.maintainers.fazzi;
      platforms = ["x86_64-linux"];
    };
  })
