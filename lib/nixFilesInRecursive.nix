lib:
let
  inherit (lib) filesystem hasSuffix hasPrefix;
in
path:
let
  files = filesystem.listFilesRecursive path;
  nixFilter =
    file:
    let
      name = baseNameOf file;
    in
    hasSuffix ".nix" name && !(hasPrefix "_" name);
in
builtins.filter nixFilter files
