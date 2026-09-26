{ pkgs, kernel }:

let

  kernelBuild = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in
pkgs.stdenv.mkDerivation {
  pname = "snd-usb-audio-patched";
  version = "${kernel.version}";

  src = kernel.src;

  dontConfigure = true;

  patches = [
    ./0001-Fix-Audient-EVO4-master-playback-control-name.patch
    ./0002-Add-Audient-EVO4-mixer-quirks.patch
  ];

  buildPhase = ''
    runHook preBuild

    make -C "${kernelBuild}" \
      M="$PWD/sound/usb" \
      modules

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 \
      sound/usb/snd-usb-audio.ko \
      "$out/lib/modules/${kernel.modDirVersion}/kernel/sound/usb/snd-usb-audio.ko"

    runHook postInstall
  '';

  meta = {
    description = "Patched snd-usb-audio kernel module with Audient EVO4 support";
    license = pkgs.lib.licenses.gpl2Only;
  };
}
