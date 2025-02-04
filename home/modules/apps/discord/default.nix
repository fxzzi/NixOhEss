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
              --add-flags "--use-cmd-decoder=passthrough" \
              --add-flags "--enable-gpu-rasterization" \
              --add-flags "--enable-zero-copy" \
              --add-flags "--ignore-gpu-blocklist" \
              --add-flags "--enable-features=AcceleratedVideoDecodeLinuxGL" \
              --add-flags "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL" \
              --add-flags "--enable-features=VaapiOnNvidiaGPUs" \
              --add-flags "--enable-features=VaapiIgnoreDriverChecks" \
              --add-flags "--enable-features=AcceleratedVideoEncoder" \
              --add-flags "--enable-features=AcceleratedVideoDecoder" \
              --add-flags "--enable-features=WaylandLinuxDrmSyncobj" \
              --add-flags "--disable-features=WebRtcAllowInputVolumeAdjustment"
          '';
        }))
    ];
  };
}
