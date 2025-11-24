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

  fixupPhase = ''
    # driver is currently broken, lower number should in theory take precedence
    # however it doesn't. 11 > 10 from egl-wayland1
    mv $out/share/egl/egl_external_platform.d/09_nvidia_wayland2.json \
      $out/share/egl/egl_external_platform.d/11_nvidia_wayland2.json
    substituteInPlace "$out/share/egl/egl_external_platform.d/11_nvidia_wayland2.json" \
      --replace '"libnvidia-egl-wayland2.so.1"' "\"$out/lib/libnvidia-egl-wayland2.so.1\""
  '';

  meta = {
    description = "Dma-buf-based Wayland external platform library";
    homepage = "https://github.com/NVIDIA/egl-wayland2";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = lib.maintainers.fazzi;
  };
}
