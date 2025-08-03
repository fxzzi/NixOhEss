{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  inherit (builtins) attrNames readDir map readFile;
  cfg = config.cfg.programs.scripts;
  binDir = ./bin;
  shellScripts = attrNames (readDir binDir); # List of script names in ./bin
  scriptPackages = map (name: pkgs.writeShellScriptBin name (readFile "${binDir}/${name}")) shellScripts;
in {
  options.cfg.programs.scripts.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enables user scripts.";
  };
  config = mkIf cfg.enable {
    hj.packages = with pkgs;
      scriptPackages
      ++ [
        grim
        slurp
        libcanberra-gtk3
        wl-clipboard
        mpc
        jq
        ffmpeg
        libsixel
        wayfreeze
        brightnessctl
      ];
  };
}
