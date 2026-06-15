{inputs, ...}: {
  imports = [
    inputs.tack.nixosModules.default
  ];
  config = {
    programs.tack = {
      enable = true;
      nixConfTokens = true;
    };
  };
}
