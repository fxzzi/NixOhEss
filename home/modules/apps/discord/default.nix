{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.apps.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables discord and some client mods.";
  };
  config = lib.mkIf config.cfg.apps.discord.enable {
    home.packages = with pkgs; [
      ((vesktop.override {
          electron = electron_35;
          withTTS = false;
          withMiddleClickScroll = true;
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
