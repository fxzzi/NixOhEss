{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf concatStringsSep optionals;
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
  };

  config = mkIf cfg.enable {
    hj = {
      xdg.config.files."discord/settings.json" = {
        generator = lib.generators.toJSON {};
        value = let
          endpoint = "https://inject.shelter.uwu.network/equicord";
        in {
          SKIP_HOST_UPDATE = true;
          MINIMIZE_TO_TRAY = cfg.minimizeToTray;
          OPEN_ON_STARTUP = false;
          DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
          enableHardwareAcceleration = true;
          # use vencord through sheltupdate instead of using nixpkgs vencord
          # this means we can get faster vencord updates outside of nixpkgs
          UPDATE_ENDPOINT = endpoint;
          NEW_UPDATE_ENDPOINT = "${endpoint}/";
          openasar = {
            setup = true;
            # using the performance preset breaks vaapi
            cmdPreset = "balanced";
            # quickstart is buggy and breaks discord sometimes.
            quickstart = false;
            # this css is made for discord compact mode. if you're not using that, stuff won't align!!
            css =
              # css
              ''
                /* Hide nitro begging */
                @import url("https://raw.codeberg.page/AllPurposeMat/Disblock-Origin/DisblockOrigin.theme.css");

                /* Hide the Visual Refresh title bar */
                .visual-refresh {
                  /* Hide the bar itself */
                  --custom-app-top-bar-height: 0px !important;

                  /* Title bar buttons are still visible so hide them too */
                  div.base__5e434 > div.bar_c38106 {
                    display: none;
                  }

                  /* Bring the server list down a few pixels */
                  ul[data-list-id="guildsnav"] > div.itemsContainer_ef3116 {
                    margin-top: 8px;
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
                  font-size: 9.5pt;
                  font-weight: normal;
                }

                /* Hide Discover button */
                div[data-list-item-id="guildsnav___guild-discover-button"] {
                  display: none !important;
                }

                /* Hide voice settings menus in user panel */
                div[class^="audioButtonParent__"] button[role="switch"] {
                  border-radius: var(--radius-sm);
                  & ~ button { display: none; }
                }
                /* Also reduce the gap between the buttons */
                div.container__37e49 > div.buttons__37e49 {
                  gap: 1px;
                }
              '';
          };
        };
      };
      packages = [
        (pkgs.discord.override {
          # we disable updates in settings.json
          disableUpdates = false;
          commandLineArgs = joinedArgs;
          withTTS = false;
          enableAutoscroll = true;
          withOpenASAR = true;
        })
      ];
    };
  };
}
