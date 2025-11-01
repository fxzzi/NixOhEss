{lib, ...}: let
  inherit (lib) filesystem hasSuffix hasPrefix;

  # list every file recursively in ./
  allNixFiles = filesystem.listFilesRecursive ./.;

  filterFile = path: let
    name = baseNameOf path;
  in
    path
    != ./default.nix # don't re-import this file
    && hasSuffix ".nix" name # make sure every file is a .nix file
    && ! hasPrefix "_" name; # files starting with _ shouldn't be imported
in {
  flake.nixosModules.default = {
    imports = builtins.filter filterFile allNixFiles;
  };
}
