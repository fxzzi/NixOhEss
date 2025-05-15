{
  pkgs,
  lib,
  config,
  ...
}: let
  commandLineArgs =
    [
      "--disable-features=WebRtcAllowInputVolumeAdjustment" # stop chromium from messing with my mic volume
      # attempt to disable noise suppression? This also disables echo cancellation too tho.
      "--disable-features=ChromeWideEchoCancellation"
    ]
    ++ lib.optionals config.cfg.gpu.nvidia.enable [
      "--enable-features=WaylandLinuxDrmSyncobj" # fix flickering
      # attempt to enable hardware acceleration
      # FIXME: not working on Electron yet?
      # "--enable-features=AcceleratedVideoDecodeLinuxGL"
      # "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL"
      # "--enable-features=VaapiOnNvidiaGPUs"
      # "--enable-features=VaapiIgnoreDriverChecks"
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
  options.cfg.apps.discord.enable = lib.mkEnableOption "discord";

  config = lib.mkIf config.cfg.apps.discord.enable {
    hj = {
      files.".config/vesktop/settings/quickCss.css".text =
        # css
        ''
          /* Hide nitro begging */
          @import url("https://allpurposem.at/disblock/DisblockOrigin.theme.css");

          /* Hide the Visual Refresh title bar */
          @import url("https://raw.githubusercontent.com/surgedevs/visual-refresh-compact-title-bar/refs/heads/main/hidden.css");

          /* Align the chat box with the user panel */
          form>div[class^="channelBottomBarArea_"],
          form>div>div[class^="channelBottomBarArea_"] {
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

          /* reduce context menu padding */
          .scroller_c1e9c4{
              margin: -4px;
              &::after,.separator_c1e9c4 {
                  margin: 1px 8px !important;
              }
              &::after,.wrapper_f563df {
                  padding: 2px !important;
              }
              &::after,.item_c1e9c4{
                  /* min-height is 32px as default, change value for desired look */
                  min-height: 32;
                  /* padding is 4px 8px as default, change value for desired look */
                  padding: 4px 8px;
              }
          }
          /* Chatbox buttons */
          form>div>div[class^=channelBottomBarArea_] {
            div[class^="buttons_"]
            {
              /* Send gift button (both versions) */
              > div:has(div[class*="trinketsIcon_"]), > button { display: none; }

              /* GIF picker button */
              div[class^="expression-picker-chat-input-button"]:has( + div[class^="expression-picker-chat-input-button"] div[class*="stickerButton_"]) { display: var(--display-gif-button, flex); }

              /* Sticker picker button */
              div[class^="expression-picker-chat-input-button"]:has(div[class*="stickerButton_"]) { display: var(--display-sticker-button, flex); }
            }

            /* Apps button (right) */
            div[class^="channelAppLauncher_"] { display: var(--display-app-launcher); }
          }

        '';

      packages = with pkgs; [
        (
          (vesktop.override {
            electron = pkgs.electron_36;
            withTTS = false;
            withMiddleClickScroll = true;
          }).overrideAttrs
          (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
            postFixup = ''
              ${old.postFixup or ""}
              # add command line args like chromium
              wrapProgramShell $out/bin/vesktop --add-flags "${joinedArgs}"
            '';
          })
        )
      ];
    };
  };
}
