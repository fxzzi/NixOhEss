{
  _module.args = {
    # Pass `pins` to flake-parts' module args. This allows
    # parts of the module system to refer to them in a more concise
    # way than importing them directly.
    pins = import ./npins;
  };

  imports = [
    ./lib
    ./pkgs
    ./fmt.nix
  ];
}
