{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  commandLineArgs =
    [
      "--disable-smooth-scrolling"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ]
    ++ lib.optionals osConfig.cfg.gpu.nvidia.enable [
      "--enable-features=WaylandLinuxDrmSyncobj"
    ];

  joinedArgs = lib.concatStringsSep " " commandLineArgs;
in {
  options.cfg.apps.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables discord and some client mods.";
  };

  config = lib.mkIf config.cfg.apps.discord.enable {
    xdg.configFile."vesktop/settings/quickCss.css".source = ./quickCss.css;

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
