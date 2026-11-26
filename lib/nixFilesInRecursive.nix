lib:
let
  inherit (lib) filesystem hasSuffix;
in
path:
let
  files = filesystem.listFilesRecursive path;
  nixFilter =
    file:
    let
      name = baseNameOf file;
    in
    hasSuffix ".nix" name;
in
builtins.filter nixFilter files
