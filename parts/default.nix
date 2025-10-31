{
  _module.args = {
    pins = import ./npins;
  };

  imports = [
    ./lib
    ./pkgs
    ./fmt.nix
  ];
}
