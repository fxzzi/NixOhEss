{
  pkgs,
  lib,
  config,
  ...
}: let
  binDir = ./bin;
  shellScripts = builtins.attrNames (builtins.readDir binDir); # List of script names in ./bin
  scriptPackages =
    builtins.map (
      name: pkgs.writeShellScriptBin name (builtins.readFile "${binDir}/${name}")
    )
    shellScripts;
in {
  options.cfg.scripts.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables user scripts.";
  };
  config = lib.mkIf config.cfg.scripts.enable {
    home.packages = with pkgs;
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
      ];
  };
}
