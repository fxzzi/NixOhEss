{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  mpv,
  libappindicator,
  libsoup_3,
  makeWrapper,
  nodejs,
  webkitgtk_6_0,
  libadwaita,
  libepoxy,
  gettext,
  wrapGAppsHook4,
  glib-networking,
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
    glib-networking
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    makeWrapper
    pkg-config
    gettext
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
    license = with lib.licenses; [
      gpl3Only
      unfree
    ];
    maintainers = lib.maintainers.fazzi;
    platforms = lib.platforms.linux;
  };
}
