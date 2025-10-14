{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  mesa,
  libdrm,
  libglvnd,
  libgbm,
  wayland,
  wayland-protocols,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "egl-wayland2";
  rev = "eb31eb3674829a12e8b49dee17b5f3d3ab92d31d";
  version = "0-unstable-${builtins.substring 0 8 finalAttrs.rev}";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-wayland2";
    inherit (finalAttrs) rev;
    hash = "sha256-+cEpOS5te0Hedx/5dyqUxLedkVjfcFPto15B/gdLboA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    mesa
    libglvnd
    libdrm
    libgbm
    wayland
    wayland-protocols
  ];

  propagatedBuildInputs = [
    eglexternalplatform
  ];

  meta = {
    description = "Dma-buf-based Wayland external platform library";
    homepage = "https://github.com/NVIDIA/egl-wayland2";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = lib.maintainers.fazzi;
  };
})
