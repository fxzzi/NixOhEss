{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) fetchurl stdenv;
  cfg = config.cfg.programs.eden;
  eden = stdenv.mkDerivation rec {
    pname = "eden";
    version = "0.0.3-rc2";

    src = fetchurl {
      url = "https://github.com/eden-emulator/Releases/releases/download/v${version}/Eden-Linux-v${version}-amd64.AppImage";
      sha256 = "sha256-l5LxjKO6V7mTIDg6w7sVauzQWtQW6JwHx6FHlPDM7c0=";
    };

    desktopItem = fetchurl {
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/v${version}/dist/org.eden_emu.eden.desktop";
      sha256 = "sha256-xJBSZfNUYSulha0+dsMsNCWLBby1POXw+UEqa+pRMA0=";
    };
    desktopIcon = fetchurl {
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/v${version}/dist/org.eden_emu.eden.svg";
      sha256 = "sha256-18Zae6k6C10mANg8rgOpia3zJxnI1Gq3wrKmc/H9jp0=";
    };

    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${pname}
      chmod +x $out/bin/${pname}
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
      cp ${desktopItem} $out/share/applications/org.eden_emu.eden.desktop
      cp ${desktopIcon} $out/share/icons/hicolor/scalable/apps/org.eden_emu.eden.svg
    '';
  };
in {
  options.cfg.programs.eden.enable = mkEnableOption "Eden Emulator";
  config = mkIf cfg.enable {
    hj.packages = [eden];
  };
}
