{
  pkgs,
  lib,
  config,
  inputs,
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
    [
      "--enable-features=${lib.concatStringsSep "," enableFeatures}"
      "--disable-features=${lib.concatStringsSep "," disableFeatures}"
    ]
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
    moonlight = {
      enable = lib.mkEnableOption "Moonlight for discord";
      declaredExtensions = lib.mkEnableOption "Declared extensions for moonlight";
    };
  };

  imports = [
    ./vesktop.nix
  ];

  config = lib.mkIf cfg.enable {
    hj = {
      files = {
        ".config/moonlight-mod/extensions" = {
          enable = cfg.moonlight.enable && cfg.moonlight.declaredExtensions;
          source = "${inputs.moonlight-exts}/exts";
        };
        ".config/moonlight-mod/canary.json" = {
          enable = cfg.moonlight.enable && cfg.moonlight.declaredExtensions;
          text = builtins.toJSON {
            extensions = {
              moonbase = false;
              disableSentry = true;
              noTrack = true;
              noHideToken = true;
              betterCodeblocks = true;
              betterTags = true;
              betterUploadButton = true;
              betterEmbedsYT = true;
              callTimer = true;
              clearUrls = true;
              cloneExpressions = false;
              copyAvatarUrl = true;
              doubleClickActions = true;
              freeScreenShare = true;
              freeMoji = true;
              inviteToNowhere = true;
              muteGuildOnJoin = true;
              nativeFixes = {
                enabled = true;
                config = {
                  vaapiIgnoreDriverChecks = true;
                  linuxAutoscroll = true;
                  vulkan = true;
                };
              };
              noHelp = true;
              noRpc = true;
              resolver = true;
              showMediaOptions = true;
              unindent = true;
            };

            repositories = [];
          };
        };

        ".config/discordcanary/settings.json" = {
          text = builtins.toJSON {
            SKIP_HOST_UPDATE = true;
            MINIMIZE_TO_TRAY = cfg.minimizeToTray;
            OPEN_ON_STARTUP = false;
            DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
            openasar = {
              setup = true;
              quickstart = false;
              css =
                # css
                ''
                  /* Hide nitro begging */
                  @import url("https://allpurposem.at/disblock/DisblockOrigin.theme.css");

                  /* Hide the Visual Refresh title bar */
                  @import url("https://surgedevs.github.io/visual-refresh-compact-title-bar/browser.css");

                  /* Use system fonts for UI */
                  :root {
                    --font-primary: ${primaryFont} !important;
                    --font-display: ${primaryFont} !important;
                    --font-headline: ${primaryFont} !important;
                    --font-code: ${monoFont} !important;
                    /* Make the sidebar line up correctly with disabled title bar */
                    --vr-header-snippet-server-padding: 8px !important;
                  }

                  /* Align the chat box with the user panel */
                  form div[class^="channelBottomBarArea_"] {
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

                  /* Hide "Now Playing" section on friends list */
                  div[class^="nowPlayingColumn_"] {
                    display: none !important;
                  }

                  /* Make "Read All" vencord button text smaller */
                  button.vc-ranb-button {
                    font-size: 11px;
                    font-weight: normal;
                  }
                '';
            };
          };
        };
      };
      packages = with pkgs; [
        (
          (discord-canary.override {
            withTTS = false;
            enableAutoscroll = true;
            withOpenASAR = true;
            withMoonlight = cfg.moonlight.enable;
            withVencord = cfg.vencord.enable;
            disableUpdates = true;
          }).overrideAttrs
          (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
            postFixup = ''
              ${old.postFixup or ""}
              # add command line args like chromium
              wrapProgramShell $out/bin/DiscordCanary \
              --add-flags "${joinedArgs}" \
              --set LD_LIBRARY_PATH "${lib.makeLibraryPath [
                pkgs.libva
              ]}"
            '';
          })
        )
      ];
    };
  };
}
