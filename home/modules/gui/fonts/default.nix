{
  pkgs,
  config,
  lib,
  ...
}: {
  options.cfg.gui.fontConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables font configurations";
  };
  config = lib.mkIf config.cfg.gui.fontConfig.enable {
    home.packages = with pkgs; [
      inter
      noto-fonts # Google Noto Fonts
      noto-fonts-emoji # Emoji Font
      noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
      icomoon-feather
      # corefonts # ms fonts.
      (pkgs.callPackage ./ioshelfka-term-nerd.nix {})
    ];
    gtk = {
      font = {
        name = "Inter Variable";
        size = 11;
      };
    };
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif =
          [
            "Noto Serif"
          ]
          ++ config.fonts.fontconfig.defaultFonts.emoji;
        sansSerif =
          [
            config.gtk.font.name
            "Noto Sans"
          ]
          ++ config.fonts.fontconfig.defaultFonts.emoji;
        monospace = [
          "IoshelfkaTerm Nerd Font"
          "icomoon-feather"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
