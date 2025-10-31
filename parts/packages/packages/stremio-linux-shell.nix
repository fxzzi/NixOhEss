{
  lib,
  rustPlatform,
  makeWrapper,
  openssl,
  pkg-config,
  wrapGAppsHook4,
  libadwaita,
  libepoxy,
  mpv,
  webkitgtk_6_0,
  libsoup_3,
  nodejs,
  pins,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "stremio-linux-shell";
  version = "0-unstable-${builtins.substring 0 8 pins.stremio-linux-shell.revision}";

  src = pins.stremio-linux-shell;
  cargoLock.lockFile = "${pins.stremio-linux-shell}/Cargo.lock";

  buildInputs = [
    webkitgtk_6_0
    libadwaita
    libepoxy
    libsoup_3
    openssl
    mpv
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    makeWrapper
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps

    mv $out/bin/stremio-linux-shell $out/bin/stremio
    cp $src/data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop
    cp $src/data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    wrapProgram $out/bin/stremio \
       --prefix PATH : ${lib.makeBinPath [nodejs]}
  '';

  meta = {
    mainProgram = "stremio";
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    license = lib.licenses.gpl3Only;
    maintainers = lib.maintainers.fazzi;
    platforms = lib.platforms.linux;
  };
}
