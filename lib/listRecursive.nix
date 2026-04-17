lib: let
  inherit (lib) filesystem hasSuffix;
in
  path: let
    files = filesystem.listFilesRecursive path;
    nixFilter = file: hasSuffix ".nix" (baseNameOf file);
  in
    builtins.filter nixFilter files
