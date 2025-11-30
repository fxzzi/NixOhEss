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
  pins,
  ...
}: let
  # upstream uses cef 138.0.21
  cef = cef-binary.override {
    version = "138.0.21";
    gitRevision = "54811fe";
    chromiumVersion = "138.0.7204.101";

    srcHashes = {
      "x86_64-linux" = "sha256-Kob/5lPdZc9JIPxzqiJXNSMaxLuAvNQKdd/AZDiXvNI=";
    };
  };
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

    cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";
    cargoLock.outputHashes = {
      # some hashes are missing from the cargo lockfile? Not sure why
      "cef-138.2.2+138.0.21" = "sha256-HfhiNwhCtKcuI27fGTCjk1HA1Icau6SUjXjHqAOllAk=";
      "dpi-0.1.1" = "sha256-5nc8cGFl4jUsJXfEtfOxFBQFRoBrM6/5xfA2c1qhmoQ=";
      "glutin-0.32.3" = "sha256-5IX+03mQmWxlCdVC0g1q2J+ulW+nPTAhYAd25wyaHx8=";
      "libmpv2-4.1.0" = "sha256-zXMFuajnkY8RnVGlvXlZfoMpfifzqzJnt28a+yPZmcQ=";
    };

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
      # copy vendored server.js, shell no longer fetches at runtime
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
