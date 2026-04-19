{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf optionalAttrs;
  cfg = config.cfg.programs.steam;
in {
  options.cfg.programs.steam = {
    enable = mkEnableOption "steam";
    shaderThreads = mkOption {
      type = types.int;
      default = 1;
      description = "Number of threads to use for shader processing in Steam.";
    };
  };
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = optionalAttrs config.cfg.programs.obs-studio.enable 1;
          # allow using the nvidia reflex layer.
          # according to nvidia it can cause issues in apps which
          # don't even use reflex, so enable it in here only for lutris
          DXVK_NVAPI_VKREFLEX = optionalAttrs config.cfg.hardware.nvidia.enable 1;
          MANGOHUD = optionalAttrs config.cfg.programs.mangohud.enable 1;
          # FIXME: https://github.com/ValveSoftware/steam-for-linux/issues/13007
          PRESSURE_VESSEL_FILESYSTEMS_RW = optionalAttrs (builtins.hasAttr "/games" config.fileSystems) "/games";
        };
        # also FIXME: https://github.com/NixOS/nixpkgs/issues/505824#issuecomment-4277025012
        buildFHSEnv = args:
          pkgs.buildFHSEnv (args
            // {
              extraBuildCommands =
                (args.extraBuildCommands or "")
                + ''
                  rm -f $out/usr/sbin/ldconfig
                  cp ${pkgs.pkgsi686Linux.glibc.bin}/bin/ldconfig $out/usr/sbin/ldconfig
                '';
            });
      };
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = mkIf config.cfg.programs.proton-ge.enable [pkgs.proton-ge-bin];
    };
    hj = {
      xdg.data.files."Steam/steam_dev.cfg".text = ''
        unShaderBackgroundProcessingThreads ${toString cfg.shaderThreads}
      '';
    };
    hardware.steam-hardware.enable = true;
  };
}
