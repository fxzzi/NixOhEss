{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf makeLibraryPath concatStringsSep optionals;
  cfg = config.cfg.programs.discord;
  disableFeatures = [
    "WebRtcAllowInputVolumeAdjustment"
    "ChromeWideEchoCancellation"
  ];
  enableFeatures =
    [
      "AcceleratedVideoDecodeLinuxGL"
      "AcceleratedVideoDecodeLinuxZeroCopyGL"
      "VaapiIgnoreDriverChecks"
    ]
    ++ optionals config.cfg.hardware.nvidia.enable [
      "WaylandLinuxDrmSyncobj" # fix flickering
      # attempt to enable hardware acceleration
      "VaapiOnNvidiaGPUs"
    ];

  commandLineArgs =
    optionals (enableFeatures != []) [
      "--enable-features=${concatStringsSep "," enableFeatures}"
    ]
    ++ optionals (disableFeatures != []) [
      "--disable-features=${concatStringsSep "," disableFeatures}"
    ]
    ++ optionals (!config.cfg.programs.smoothScroll.enable) [
      "--disable-smooth-scrolling"
    ];

  joinedArgs = concatStringsSep " " commandLineArgs;

  # Use the below variables to create a list of fonts which can
  # be used in openasar quickcss.

  # It works by parsing the list of fonts from fontconfig and
  # wrapping them in quotes and separating them with commas.
  # for some reason, I couldn't just use `sans-serif` and `monospace`
  # as it wouldn't render correctly, i.e. no bold text, text was squished.
  # Explicity listing the fonts however seems to have worked.
  font = config.fonts.fontconfig.defaultFonts;
  wrapFonts = fonts: concatStringsSep ", " (map (f: "\"${f}\"") fonts);

  primaryFont = wrapFonts (font.sansSerif ++ font.emoji);
  monoFont = wrapFonts font.monospace;
in {
  options.cfg.programs.discord = {
    enable = mkEnableOption "discord";
    minimizeToTray =
      mkEnableOption "Minimize to tray"
      // {default = true;};
    vencord.enable = mkEnableOption "Vencord for discord";
  };

  config = mkIf cfg.enable {
    hj = {
      xdg.config.files."discord/settings.json" = {
        generator = lib.generators.toJSON {};
        value = {
          SKIP_HOST_UPDATE = true;
          MINIMIZE_TO_TRAY = cfg.minimizeToTray;
          OPEN_ON_STARTUP = false;
          DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
          enableHardwareAcceleration = true;
          openasar = {
            setup = true;
            cmdPreset = "balanced";
            quickstart = true;
            # this css is made for discord compact mode. if you're not using that, stuff won't align!!
            css =
              # css
              ''
                /* Hide nitro begging */
                @import url("https://raw.codeberg.page/AllPurposeMat/Disblock-Origin/DisblockOrigin.theme.css");

                /* Hide the Visual Refresh title bar */
                .visual-refresh {
                  /* Hide the bar itself */
                  --custom-app-top-bar-height: 0 !important;

                  /* Title bar buttons are still visible so hide them too */
                  div.base_c48ade > div.bar_c38106 {
                    display: none;
                  }

                  /* Bring the server list down a few pixels */
                  ul[data-list-id="guildsnav"] > div.itemsContainer_ef3116 {
                    margin-top: 6px;
                  }
                }

                :root {
                  /* Use system fonts for UI */
                  --font-primary: ${primaryFont} !important;
                  --font-display: ${primaryFont} !important;
                  --font-headline: ${primaryFont} !important;
                  --font-code: ${monoFont} !important;

                  /* Disblock settings */
                  --display-clan-tags: none;
                  --display-active-now: none;
                  --display-hover-reaction-emoji: none;
                  --bool-show-name-gradients: false;
                }

                /* Make "Read All" vencord button text smaller */
                button.vc-ranb-button {
                  font-size: 11.5px;
                  font-weight: normal;
                }
              '';
          };
        };
      };
      packages = with pkgs; [
        (
          (discord.override {
            disableUpdates = false;
            withTTS = false;
            enableAutoscroll = true;
            withOpenASAR = true;
            withVencord = cfg.vencord.enable;
          }).overrideAttrs
          (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
            postFixup = ''
              ${old.postFixup or ""}
              # add command line args like chromium
              wrapProgram $out/opt/Discord/Discord \
              --add-flags "${joinedArgs}" \
              --set LD_LIBRARY_PATH "${makeLibraryPath [pkgs.libva]}"
            '';
          })
        )
      ];
    };
  };
}
