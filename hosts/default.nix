{
  self,
  inputs,
  pins,
  ...
}: let
  inherit (inputs.nixpkgs.lib) genAttrs nixosSystem filterAttrs;
  inherit (builtins) attrNames readDir;

  # Filter readDir to only include directories
  # This avoids pulling in this file (default.nix) as a host
  dirs = filterAttrs (_: type: type == "directory") (readDir ./.);

  mkSystem = hostName:
    nixosSystem {
      specialArgs = {
        inherit self inputs hostName pins;
      };
      modules = [
        ../modules
        ./${hostName}
      ];
    };
in {
  flake.nixosConfigurations =
    genAttrs
    (attrNames dirs)
    mkSystem;
}
