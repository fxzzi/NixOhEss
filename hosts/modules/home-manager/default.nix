{
  inputs,
  npins,
  user,
  hostName,
  lib,
  config,
  ...
}: {
  options.home-manager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the home manager configurations.";
  };
  config = lib.mkIf config.home-manager.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      users.${user} = import ../../../home/${hostName}.nix;
      extraSpecialArgs = {
        inherit
          inputs
          npins
          user
          hostName
          ;
      };
    };
  };
}
