{
  pkgs,
  lib,
  config,
  ...
}: {
  options.apps.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables discord and some client mods.";
  };
  config = lib.mkIf config.apps.discord.enable {
    home.packages = with pkgs; [
      ((discord-canary.override {
          withOpenASAR = true;
          withVencord = true;
        })
        .overrideAttrs
        (old: {
          nativeBuildInputs = old.nativeBuildInputs or [] ++ [pkgs.makeWrapper];
          postInstall = ''
            ${old.postInstall or ""}
            wrapProgramShell $out/opt/DiscordCanary/DiscordCanary \
              --add-flags "--disable-smooth-scrolling" \
              --add-flags "--disable-features=WebRtcAllowInputVolumeAdjustment"
          '';
        }))
    ];
  };
}
