{
  lib,
  stdenv,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  libdrm,
  libglvnd,
  libgbm,
  wayland,
  wayland-protocols,
  pins,
}:
stdenv.mkDerivation {
  pname = "egl-wayland2";
  version = "0-unstable-${builtins.substring 0 8 pins.egl-wayland2.revision}";

  src = pins.egl-wayland2;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
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
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = lib.maintainers.fazzi;
  };
}
