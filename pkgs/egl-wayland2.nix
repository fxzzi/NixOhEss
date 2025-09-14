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
  rev = "d4deb7c371aac2a304522ffc297fcb71e6507699";
  version = "0-unstable-${builtins.substring 0 8 finalAttrs.rev}";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-wayland2";
    inherit (finalAttrs) rev;
    hash = "sha256-xJU1FZRrNf4kcS+vvbArABwSvkzAC1+gVzIRBHLay6A=";
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
