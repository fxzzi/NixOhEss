{
  fetchurl,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "eden";
  version = "0.0.4-rc1";

  src = fetchurl {
    # 0.0.4-rc1 has a bug, so use a nightly build for now instead
    # url = "https://github.com/eden-emulator/Releases/releases/download/v${finalAttrs.version}/Eden-Linux-v${finalAttrs.version}-amd64-gcc-standard.AppImage";
    url = "https://github.com/pflyly/eden-nightly/releases/download/2025-10-30-27931/Eden-27931-Common-PGO-x86_64.AppImage";
    sha256 = "sha256-e8eCUnTGByFf18TDqF3SEiazpdylaK99ZTwQ67Fr3+s=";
  };

  desktopItem = fetchurl {
    url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/v${finalAttrs.version}/dist/dev.eden_emu.eden.desktop";
    sha256 = "sha256-TJS+y7I36M1GgoeGvmzEP8OsQ77AvQrV3GH6RmHxwOA=";
  };

  desktopIcon = fetchurl {
    url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/v${finalAttrs.version}/dist/dev.eden_emu.eden.svg";
    sha256 = "sha256-ghAFsbKArr2jBtSkEWx8k3uoFLNEcpaWuzs7Fpb17/I=";
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${finalAttrs.pname}
    chmod +x $out/bin/${finalAttrs.pname}

    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp ${finalAttrs.desktopItem} $out/share/applications/dev.eden_emu.eden.desktop
    cp ${finalAttrs.desktopIcon} $out/share/icons/hicolor/scalable/apps/dev.eden_emu.eden.svg
  '';
})
