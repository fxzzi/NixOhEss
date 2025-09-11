{
  lib,
  rustPlatform,
  fetchFromGitHub,
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
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stremio-linux-shell";
  rev = "0dae774166e6cd2fd17999779cfb475d20a52ab4";
  version = "0-unstable-${builtins.substring 0 8 finalAttrs.rev}";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-linux-shell";
    inherit (finalAttrs) rev;
    sha256 = "sha256-OZbOXNvU+3usKCOVb5VKHA4H7jxnKJf6bw/BuhI2awY=";
  };

  cargoHash = "sha256-6LxveTep6Fu2KHaN2A/YqKvxx7uyEE2U05FK88RFW7M=";

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
})
