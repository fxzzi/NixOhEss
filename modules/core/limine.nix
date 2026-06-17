{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkIf;
in {
  # HACK: limine lets you do a float for the timeout.
  # by default the nix timeout option can only be an int though.
  disabledModules = ["system/boot/loader/loader.nix"];
  options = {
    boot.loader.timeout = mkOption {
      default = 5;
      type = types.nullOr types.number;
      description = ''
        Timeout (in seconds) until loader boots the default menu item. Use null if the loader menu should be displayed indefinitely.
      '';
    };
    cfg.core.limine.timeout = mkOption {
      type = types.number;
      default = 5;
      description = ''
        Sets the timeout in seconds for the boot menu to automatically continue.
        Setting to < 1 will also enable quiet boot.
      '';
    };
  };
  config = {
    boot = {
      initrd.systemd.enable = true;
      loader = {
        efi.canTouchEfiVariables = true;
        inherit (config.cfg.core.limine) timeout;
        limine = {
          enable = true;
          maxGenerations = 8;
          style = {
            wallpaperStyle = "centered";
            wallpapers =
              map
              (file: "${inputs.walls}/images/${file}")
              [
                "fuji.jpg"
                "cherry-blossom.jpg"
                "clouds.jpg"
                "austria_landscape.jpg"
                "pink_flowers.jpg"
                "wallhaven-9oxkwk_3840x2160.jpg"
                "wallhaven-28v3mm_3840x2160.jpg"
                "wallhaven-rqy1mm.jpg"
                "wallhaven-og39mm.jpg"
                "wallhaven-21dlrg.jpg"
                "norway-lofoten-island.jpg"
              ];
            interface = {
              resolution = "max";
              helpHidden = true;
              branding = "Limine Bootloader";
            };
            graphicalTerminal = {
              font.scale = "2x2";
              # don't have any margin around the background colour
              margin = -1;
              marginGradient = -1;
              # darken the wallpapers
              background = "33080808";
              foreground = "B9C1D6";
            };
          };
          extraEntries = ''
            /Windoesn't
                protocol: efi
                path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
          '';
          extraConfig = mkIf (config.cfg.core.limine.timeout < 1) ''
            quiet: yes
          '';
        };
      };
    };
  };
}
