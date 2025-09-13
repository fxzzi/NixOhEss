{
  fetchurl,
  stdenv,
  makeWrapper,
}: let
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "eden";
    version = "0.0.3";

    src = fetchurl {
      url = "https://github.com/eden-emulator/Releases/releases/download/v${finalAttrs.version}/Eden-Linux-v${finalAttrs.version}-amd64.AppImage";
      sha256 = "sha256-P2Qy1VdSvKXvPNJKzzIzLxMumS5BQ79bOC0FTgFHMiw=";
    };

    desktopItem = fetchurl {
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/v${finalAttrs.version}/dist/org.eden_emu.eden.desktop";
      sha256 = "sha256-fzLSjy2eIOrz2q3cN78P5ZUpUFnaohG9nGHK/csSiK0=";
    };

    desktopIcon = fetchurl {
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/v${finalAttrs.version}/dist/org.eden_emu.eden.svg";
      sha256 = "sha256-ghAFsbKArr2jBtSkEWx8k3uoFLNEcpaWuzs7Fpb17/I=";
    };

    nativeBuildInputs = [makeWrapper];

    phases = ["installPhase"];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${finalAttrs.pname}
      chmod +x $out/bin/${finalAttrs.pname}

      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
      cp ${finalAttrs.desktopItem} $out/share/applications/org.eden_emu.eden.desktop
      cp ${finalAttrs.desktopIcon} $out/share/icons/hicolor/scalable/apps/org.eden_emu.eden.svg

      # fix eden being unable to find gpu icd's for nvidia
      wrapProgram $out/bin/${finalAttrs.pname} \
        --set XDG_DATA_DIRS "\$XDG_DATA_DIRS:/run/opengl-driver/share"
    '';
  })
