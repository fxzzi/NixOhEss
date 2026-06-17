{inputs, ...}: {
  imports = [
    inputs.nixos-core.nixosModules.default
  ];
  config = {
    system.nixos-core.enable = true;
  };
}
