{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  mpv,
  makeWrapper,
  nodejs,
  webkitgtk_6_0,
  libadwaita,
  libepoxy,
  wrapGAppsHook4,
  glib-networking,
  pins,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stremio-linux-shell";
  src = pins.stremio-rewrite;
  version = "0-unstable-${builtins.substring 0 8 finalAttrs.src.revision}";
  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  buildInputs = [
    webkitgtk_6_0
    libadwaita
    libepoxy
    openssl
    mpv
    glib-networking
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    makeWrapper
    pkg-config
  ];

  # the title bar is useless, and offloading the overlay
  # graphics to the gpu was causing some problems. mpv
  # still uses gpu decoding
  patches = [
    ./0001-window-disable-graphics-offload.patch
    ./0002-window-hide-title-bar.patch
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps
    mv $out/bin/stremio-linux-shell $out/bin/stremio
    cp $src/data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop
    cp $src/data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    # to run server.js
    # this shell has loads of weird bugs on wayland
    # so use xwayland / x11 instead.
    wrapProgram $out/bin/stremio \
       --prefix PATH : ${lib.makeBinPath [nodejs]} \
       --set GDK_BACKEND x11
  '';

  meta = {
    mainProgram = "stremio";
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    license = with lib.licenses; [
      gpl3Only
      # the server.js downloaded by the program is unfree
      unfree
    ];
    maintainers = lib.maintainers.fazzi;
    platforms = lib.platforms.linux;
  };
})
