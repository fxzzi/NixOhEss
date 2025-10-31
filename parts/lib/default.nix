{lib, ...}: {
  flake.lib = {
    generators = import ./generators lib;
  };
}
