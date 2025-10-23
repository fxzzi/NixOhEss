{lib, ...}: let
  # list every file recursively in ./
  allNixFiles = lib.filesystem.listFilesRecursive ./.;

  filterFile = path: let
    name = baseNameOf path;
  in
    path
    != ./default.nix # don't re-import this file
    && lib.hasSuffix ".nix" name # make sure every file is a .nix file
    && ! lib.hasPrefix "_" name; # files starting with _ shouldn't be imported
in {
  imports = builtins.filter filterFile allNixFiles;
}
