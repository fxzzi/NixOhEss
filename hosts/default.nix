{
  self,
  inputs,
  lib,
}:
let
  inherit (lib)
    attrNames
    genAttrs
    nixosSystem
    filterAttrs
    ;
  inherit (builtins) readDir;

  # all dirs in ./ are considered hosts.
  hostNames = attrNames (filterAttrs (_: v: v == "directory") (readDir ./.));

  mkSystem =
    hostName:
    nixosSystem {
      specialArgs = {
        inherit self inputs hostName;
      };
      modules = [
        self.nixosModules.default # all modules
      ]
      ++ self.lib.nixFilesInRecursive ./${hostName}; # host-specific
    };
in
genAttrs hostNames mkSystem
