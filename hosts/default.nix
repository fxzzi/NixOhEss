{
  self,
  inputs,
  lib,
}: let
  inherit (lib) attrNames flatten genAttrs nixosSystem filterAttrs;
  inherit (builtins) readDir;

  # all dirs in ./ are considered hosts.
  hostNames = attrNames (filterAttrs (_: v: v == "directory") (readDir ./.));

  mkSystem = hostName:
    nixosSystem {
      specialArgs = {
        inherit self inputs hostName;
      };
      modules = flatten [
        self.nixosModules.default # all modules
        (self.lib.listRecursive ./${hostName}) # host-specific
      ];
    };
in
  genAttrs hostNames mkSystem
