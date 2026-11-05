{
  lib,
  inputs,
}:
{
  generators = import ./generators { inherit lib inputs; };
  nixFilesInRecursive = import ./nixFilesInRecursive.nix lib;
  mkGraphicalService = import ./mkGraphicalService.nix lib;
}
