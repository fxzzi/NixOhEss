{
  self,
  inputs,
  pins,
  lib,
}: let
  inherit (lib) attrNames flatten genAttrs nixosSystem;
  inherit (builtins) readDir;

  hostNames = attrNames (readDir ../hosts);
  mkSystem = hostName:
    nixosSystem {
      specialArgs = {
        inherit self inputs hostName pins;
      };
      modules = flatten [
        (self.lib.listRecursive ../modules) # all modules
        (self.lib.listRecursive ../hosts/${hostName}) # host-specific
      ];
    };
in
  genAttrs hostNames mkSystem
