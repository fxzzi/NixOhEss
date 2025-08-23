{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption optionalString;
  inherit (pkgs) fetchurl stdenv;
  cfg = config.cfg.programs.eden;
  eden = stdenv.mkDerivation rec {
    pname = "eden";
    version = "0.0.3-rc3";

    src = fetchurl {
      url = "https://github.com/eden-emulator/Releases/releases/download/v${version}/Eden-Linux-v${version}-amd64.AppImage";
      sha256 = "sha256-ipgIJVwu/EVGanSZZRubkN7nhmTamMYtMxYxixckftc=";
    };

    desktopItem = fetchurl {
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/v${version}/dist/org.eden_emu.eden.desktop";
      sha256 = "sha256-fzLSjy2eIOrz2q3cN78P5ZUpUFnaohG9nGHK/csSiK0=";
    };
    desktopIcon = fetchurl {
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/v${version}/dist/org.eden_emu.eden.svg";
      sha256 = "sha256-ghAFsbKArr2jBtSkEWx8k3uoFLNEcpaWuzs7Fpb17/I=";
    };

    nativeBuildInputs = [pkgs.makeWrapper];

    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${pname}
      chmod +x $out/bin/${pname}
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
      cp ${desktopItem} $out/share/applications/org.eden_emu.eden.desktop
      cp ${desktopIcon} $out/share/icons/hicolor/scalable/apps/org.eden_emu.eden.svg
      ${optionalString config.cfg.hardware.nvidia.enable ''
        wrapProgramShell $out/bin/${pname} \
        --set XDG_DATA_DIRS "\$XDG_DATA_DIRS:${config.hardware.nvidia.package}/share"
      ''}
    '';
  };
in {
  options.cfg.programs.eden.enable = mkEnableOption "Eden Emulator";
  config = mkIf cfg.enable {
    hj.packages = [eden];
  };
}
