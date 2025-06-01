{
  pkgs,
  lib,
  config,
  ...
}: let
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
  options.cfg.apps.vesktop.enable = lib.mkEnableOption "vesktop";

  config = lib.mkIf config.cfg.apps.vesktop.enable {
    hj = {
      files.".config/vesktop/settings/quickCss.css".text =
        # css
        ''
          /* Hide nitro begging */
          @import url("https://allpurposem.at/disblock/DisblockOrigin.theme.css");

          /* Hide the Visual Refresh title bar */
          @import url("https://raw.githubusercontent.com/surgedevs/visual-refresh-compact-title-bar/refs/heads/main/hidden.css");

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
              wrapProgramShell $out/bin/vesktop \
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
