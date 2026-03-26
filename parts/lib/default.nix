{lib, ...}: {
  flake.lib = {
    generators = import ./generators lib;
    listRecursive = import ./listRecursive.nix lib;
  };
}
