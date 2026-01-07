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
    substituteInPlace "$out/share/egl/egl_external_platform.d/09_nvidia_wayland2.json" \
      --replace 'libnvidia-egl-wayland2.so.1' "$out/lib/libnvidia-egl-wayland2.so.1"
    # the nvidia driver is broken, a file starting with a lower number SHOULD have prio,
    # but currently the drivers have this logic flipped. egl-wayland1 has the prefix 10,
    # so make egl-wayland2 use 09 and 11 in case.
    # cp $out/share/egl/egl_external_platform.d/09_nvidia_wayland2.json \
    #    $out/share/egl/egl_external_platform.d/11_nvidia_wayland2.json
  '';

  meta = {
    description = "Dma-buf-based Wayland external platform library";
    homepage = "https://github.com/NVIDIA/egl-wayland2";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = lib.maintainers.fazzi;
  };
}
