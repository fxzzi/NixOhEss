{ pkgs, ... }:

let
  binDir = ./bin;
  shellScripts = builtins.attrNames (builtins.readDir binDir); # List of script names in ./bin
  scriptPackages = builtins.map (
    name: pkgs.writeShellScriptBin name (builtins.readFile "${binDir}/${name}")
  ) shellScripts;
in
{
  home.packages =
    with pkgs;
    scriptPackages
    ++ [
      grim
      slurp
      libcanberra-gtk3
      wl-clipboard
      mpc
      jq
      ffmpeg
    ];
}
