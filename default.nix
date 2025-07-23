# you may leverage the following command to build systems using this
# sudo nixos-rebuild --no-reexec --file ./default.nix -A <hostName> <boot|test|switch|...>
let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
  xLib = import ./lib pkgs.lib;

  nixosConfig = hostName: user:
    import (sources.nixpkgs + "/nixos/lib/eval-config.nix") {
      specialArgs = {
        inherit sources hostName user xLib;
      };
      modules = [
        ./modules
        ./hosts/${hostName}
      ];
    };
in {
  fazziPC = nixosConfig "fazziPC" "faaris";
  fazziGO = nixosConfig "fazziGO" "faaris";
  kunzozPC = nixosConfig "kunzozPC" "kunzoz";
}
