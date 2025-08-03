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
    version = "0.0.2";

    src = fetchurl {
      url = "https://github.com/eden-emulator/Releases/releases/download/0.0.2-pre-alpha/Eden-Linux-0.0.2-pre-alpha-amd64.AppImage";
      sha256 = "sha256-TNqQzOt/g0PP57hU3W5zuUFa+NowFE53jvm3b3CzH2s=";
    };

    desktopItem = fetchurl {
      # No tagged version yet, using master
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/branch/master/dist/eden.desktop";
      sha256 = "sha256-YNPjNPjtZ6Tk2Pi6bf4d0UAW6WxhB+gcRQx0jJlsvfk=";
    };
    desktopIcon = fetchurl {
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/0.0.2-pre-alpha/dist/eden.svg";
      sha256 = "sha256-18Zae6k6C10mANg8rgOpia3zJxnI1Gq3wrKmc/H9jp0=";
    };

    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${pname}
      chmod +x $out/bin/${pname}
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
      cp ${desktopItem} $out/share/applications/eden.desktop
      cp ${desktopIcon} $out/share/icons/hicolor/scalable/apps/eden.svg
    '';
  };
in {
  options.cfg.programs.eden.enable = mkEnableOption "Eden Emulator";
  config = mkIf cfg.enable {
    hj.packages = [eden];
  };
}
