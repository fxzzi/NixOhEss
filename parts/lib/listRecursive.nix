lib: let
  inherit (lib) filesystem hasSuffix hasPrefix;
in
  path: let
    allNixFiles = filesystem.listFilesRecursive path;
    filterFile = file: let
      name = baseNameOf file;
    in
      (hasSuffix ".nix" name)
      && (!hasPrefix "_" name);
  in
    builtins.filter filterFile allNixFiles
