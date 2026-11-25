{
  lib,
}:
{
  generators = import ./generators { inherit lib; };
  nixFilesInRecursive = import ./nixFilesInRecursive.nix lib;
  mkGraphicalService = import ./mkGraphicalService.nix lib;
}
