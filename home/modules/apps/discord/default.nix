{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  commandLineArgs =
    [
      "--disable-features=WebRtcAllowInputVolumeAdjustment" # stop chromium from messing with my mic volume
    ]
    ++ lib.optionals osConfig.cfg.gpu.nvidia.enable [
      "--enable-features=WaylandLinuxDrmSyncobj" # fix flickering
      # attempt to enable hardware acceleration
      # FIXME: not working on Electron yet?
      "--enable-features=AcceleratedVideoDecodeLinuxGL"
      "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL"
      "--enable-features=VaapiOnNvidiaGPUs"
      "--enable-features=VaapiIgnoreDriverChecks"
    ]
    ++ lib.optionals (!config.cfg.gui.smoothScroll.enable) [
      "--disable-smooth-scrolling"
    ];
  joinedArgs = lib.concatStringsSep " " commandLineArgs;

  # Use the below variables to create a list of fonts which can
  # be used in vencord quickcss.

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
  options.cfg.apps.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables discord and some client mods.";
  };

  config = lib.mkIf config.cfg.apps.discord.enable {
    xdg.configFile."vesktop/settings/quickCss.css".text =
      # css
      ''
        /* Hide nitro begging */
        @import url("https://allpurposem.at/disblock/DisblockOrigin.theme.css");

        /* Hide the Visual Refresh title bar */
        @import url("https://raw.githubusercontent.com/surgedevs/visual-refresh-compact-title-bar/refs/heads/main/hidden.css");

        /* Align the chat box with the user panel */
        .visual-refresh {
          form>div[class^="channelBottomBarArea_"] {
            --custom-chat-input-margin-bottom: 6px;
            --custom-channel-textarea-text-area-height: 52px;
          }
        }

        /* Make the slowmode text smaller */
        .cooldownText_b21699 {
          font-size: 12px;
        }

        /* Hide the slowmode icon */
        .slowModeIcon_b21699 {
          display: none;
        }

        /* Use system fonts for UI */
        :root {
          --font-primary: ${primaryFont} !important;
          --font-display: ${primaryFont} !important;
          --font-headline: ${primaryFont} !important;
          --font-code: ${monoFont} !important;
          /* Make the sidebar line up correctly with disabled title bar */
          --vr-header-snippet-server-padding: 8px !important;
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

        /* Hide "Discover" icon in channel list */
        div[class="circleIconButton__5bc7e discoveryIcon_ef3116"] {
          display: none !important;
        }
      '';

    home.packages = with pkgs; [
      ((vesktop.override {
          electron = electron_35;
          withTTS = false;
          withMiddleClickScroll = true;
        })
        .overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
          postFixup = ''
            ${old.postFixup or ""}
            wrapProgramShell $out/bin/vesktop --add-flags "${joinedArgs}"
          '';
        }))
    ];
  };
}
