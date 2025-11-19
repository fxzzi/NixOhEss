{
  pkgs,
  lib,
  kernel ? pkgs.linuxPackages_latest.kernel,
}:
pkgs.stdenv.mkDerivation {
  pname = "amdgpu-kernel-module";
  inherit
    (kernel)
    src
    version
    postPatch
    nativeBuildInputs
    ;

  kernel_dev = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  modulePath = "drivers/gpu/drm/amd/amdgpu";

  patches = [
    (pkgs.fetchpatch {
      url = "https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=570a66b48c22214851949fcd71816fee280aa096";
      hash = "sha256-CU3paDbXLMJJulYRDoy+CsmX8EykrXN/7epWabSogyE=";
    })
  ];

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules
  '';

  installPhase = ''
    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install
  '';

  meta = {
    description = "AMD GPU kernel module";
    license = lib.licenses.gpl3;
  };
}
