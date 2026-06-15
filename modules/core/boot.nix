{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    mkDefault
    ;
  cfg = config.cfg.core.boot;
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
    cfg.core = {
      isLaptop = mkEnableOption "laptop";
      boot = {
        enable = mkEnableOption "boot";
        keyLayout = mkOption {
          type = types.str;
          default = "us";
          description = "Sets the keyboard layout for ttys";
        };
        timeout = mkOption {
          type = types.either types.int types.float;
          default = 5;
          description = ''
            Sets the timeout in seconds for the boot menu to automatically continue.
            Setting to < 1 will also enable quiet boot.
          '';
        };
      };
    };
  };
  imports = [
    inputs.nixos-core.nixosModules.default
  ];
  config = mkIf cfg.enable {
    system.nixos-core.enable = true;
    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
      packages = [pkgs.terminus_font];
      keyMap = cfg.keyLayout;
    };

    system.nixos.distroName = "NixOhEss";
    environment.etc.issue = {
      # a disgusting mess of escape codes to make it look nice. extra line on purpose for spacing.
      source = pkgs.writeText "issue" ''
        \e[32mWelcome to the fold of ${config.system.nixos.distroName}, \e[36m${config.cfg.core.username}\e[1;32m. \e[2m(\l)\e[0m

      '';
    };

    # Set your time zone.
    time.timeZone = mkDefault "Europe/London";

    # Select internationalisation properties.
    i18n.defaultLocale = mkDefault "en_GB.UTF-8";

    zramSwap = {
      enable = true;
      # laptop only has 16GB of RAM, so use zstd at level -1. This has better
      # compression ratio than lz4, and can therefore also have a higher memory %.
      # At the time of writing both desktops on NixOhEss have > 32GB of RAM,
      # so they can use the faster lz4 with a lower memory %.
      memoryPercent =
        if config.cfg.core.isLaptop
        then 200
        else 150;
      algorithm =
        if config.cfg.core.isLaptop
        then "zstd(level=-1)"
        else "lz4";
      # memoryPercent = 50;
      # # in bytes
      # memoryMax = 8 * 1024 * 1024 * 1024;
    };
    boot = {
      initrd.systemd.enable = true;
      loader = {
        efi.canTouchEfiVariables = true;
        inherit (cfg) timeout;
        limine = {
          enable = true;
          maxGenerations = 8;
          style = {
            wallpaperStyle = "centered";
            wallpapers = [
              "${inputs.walls}/images/fuji.jpg"
              "${inputs.walls}/images/cherry-blossom.jpg"
              "${inputs.walls}/images/clouds.jpg"
              "${inputs.walls}/images/austria_landscape.jpg"
              "${inputs.walls}/images/pink_flowers.jpg"
              "${inputs.walls}/images/wallhaven-9oxkwk_3840x2160.jpg"
              "${inputs.walls}/images/wallhaven-28v3mm_3840x2160.jpg"
              "${inputs.walls}/images/wallhaven-rqy1mm.jpg"
              "${inputs.walls}/images/wallhaven-og39mm.jpg"
              "${inputs.walls}/images/wallhaven-21dlrg.jpg"
              "${inputs.walls}/images/norway-lofoten-island.jpg"
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
          extraConfig = mkIf (cfg.timeout < 1) ''
            quiet: yes
          '';
        };
      };
      kernelParams = [
        "fbcon=font:TER16x32" # make font size bigger
        "nowatchdog" # unsafe!! but fine for personal computers
        "mitigations=off" # also unsafe!!
      ];
      tmp = {
        useTmpfs = true; # /tmp is not on tmpfs by default (why??)
        tmpfsSize = "50%"; # allow it to use x% of your RAM
      };
      extraModprobeConfig = ''
        blacklist sp5100_tco
      '';
      kernel.sysctl = {
        # zram is fast enough that we can be aggressive with swappiness
        "vm.swappiness" = 100;
        # enable sysrq / reisub
        "kernel.sysrq" = 1;
      };
    };
  };
}
