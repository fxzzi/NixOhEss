{
  lib,
  inputs,
}:
{
  generators = import ./generators { inherit lib inputs; };
  nixFilesInRecursive = import ./nixFilesInRecursive.nix lib;
}
