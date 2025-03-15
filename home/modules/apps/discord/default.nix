{
  pkgs,
  lib,
  config,
  ...
}: let
  electronVer = "36.0.0-alpha.2";
  electronPkg = pkgs.electron-bin.overrideAttrs {
    pname = "electron_36-bin";
    version = electronVer;
    src = pkgs.fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${electronVer}/electron-v${electronVer}-linux-x64.zip";
      sha256 = "sha256-h/nff4pv5bAtb2wnJFYtgAlq+GdXTMDmU6xTjvKRnh4=";
    };
  };
in {
  options.cfg.apps.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables discord and some client mods.";
  };
  config = lib.mkIf config.cfg.apps.discord.enable {
    home.packages = with pkgs; [
      ((vesktop.override {
          electron = electronPkg;
        })
        .overrideAttrs
        (old: {
          nativeBuildInputs = old.nativeBuildInputs or [] ++ [pkgs.makeWrapper];
          postFixup = ''
            ${old.postFixup or ""}
            wrapProgramShell $out/bin/vesktop \
              --add-flags "--disable-smooth-scrolling" \
              --add-flags "--disable-features=WebRtcAllowInputVolumeAdjustment" \
              --add-flags "--enable-features=WaylandLinuxDrmSyncobj" # enable explicit sync support
          '';
        }))
    ];
  };
}
