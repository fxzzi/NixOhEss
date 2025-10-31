{
  _module.args = {
    pins = import ./npins;
  };

  imports = [
    ./lib
    ./packages
    ./fmt.nix
  ];
}
