{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.obs-studio;
in {
  options.cfg.programs.obs-studio.enable = mkEnableOption "obs-studio";
  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      package =
        if (!config.cfg.hardware.nvidia.enable)
        then pkgs.obs-studio
        else
          (pkgs.symlinkJoin {
            name = "obs-studio-cbb";
            paths = [
              pkgs.obs-studio
            ];
            buildInputs = [pkgs.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/obs \
                --set LD_PRELOAD "${pkgs.cudaBoostBypass}/boost_bypass.so"
            '';
          });
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
