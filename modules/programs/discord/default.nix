{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.cfg.apps.discord;
  disableFeatures = [
    "WebRtcAllowInputVolumeAdjustment"
    "ChromeWideEchoCancellation"
  ];
  enableFeatures =
    []
    ++ lib.optionals config.cfg.gpu.nvidia.enable [
      "WaylandLinuxDrmSyncobj" # fix flickering
      # attempt to enable hardware acceleration
      "AcceleratedVideoDecodeLinuxGL"
      "AcceleratedVideoDecodeLinuxZeroCopyGL"
      "VaapiOnNvidiaGPUs"
      "VaapiIgnoreDriverChecks"
    ];

  commandLineArgs =
    (lib.optionals (enableFeatures != []) [
      "--enable-features=${lib.concatStringsSep "," enableFeatures}"
    ])
    ++ (lib.optionals (disableFeatures != []) [
      "--disable-features=${lib.concatStringsSep "," disableFeatures}"
    ])
    ++ lib.optionals (!config.cfg.gui.smoothScroll.enable) [
      "--disable-smooth-scrolling"
    ];

  joinedArgs = lib.concatStringsSep " " commandLineArgs;

  # Use the below variables to create a list of fonts which can
  # be used in openasar quickcss.

  # It works by parsing the list of fonts from fontconfig and
  # wrapping them in quotes and separating them with commas.
  # for some reason, I couldn't just use `sans-serif` and `monospace`
  # as it wouldn't render correctly, i.e. no bold text, text was squished.
  # Explicity listing the fonts however seems to have worked.
  font = config.fonts.fontconfig.defaultFonts;
  wrapFonts = fonts: lib.concatStringsSep ", " (map (f: "\"${f}\"") fonts);

  primaryFont = wrapFonts (font.sansSerif ++ font.emoji);
  monoFont = wrapFonts font.monospace;
in {
  options.cfg.apps.discord = {
    enable = lib.mkEnableOption "discord";
    minimizeToTray =
      lib.mkEnableOption "Minimize to tray"
      // {default = true;};
    vencord.enable = lib.mkEnableOption "Vencord for discord";
  };

  imports = [
    ./vesktop.nix
  ];

  config = lib.mkIf cfg.enable {
    hj = {
      files = {
        ".config/discord/settings.json" = {
          text = builtins.toJSON {
            SKIP_HOST_UPDATE = true;
            MINIMIZE_TO_TRAY = cfg.minimizeToTray;
            OPEN_ON_STARTUP = false;
            DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
            openasar = {
              setup = true;
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
                    --custom-app-top-bar-height: 0 !important;

                    /* Title bar buttons are still visible so hide them too */
                    div.base_c48ade > div.bar_c38106 {
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
                  }

                  /* Align the chat box with the user panel */
                  form div[class="channelBottomBarArea_f75fb0"] {
                    --custom-chat-input-margin-bottom: 6px;
                    --custom-channel-textarea-text-area-height: 52px;
                  }

                  /* Make the slowmode text smaller */
                  .cooldownText_b21699 {
                    font-size: 12px;
                  }

                  /* Hide the slowmode icon */
                  .slowModeIcon_b21699 {
                    display: none;
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
              wrapProgramShell $out/bin/Discord \
              --add-flags "${joinedArgs}" \
              --set LD_LIBRARY_PATH "${lib.makeLibraryPath [
                # make hw accel work
                pkgs.libva
              ]}"
            '';
          })
        )
      ];
    };
  };
}
