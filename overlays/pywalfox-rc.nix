{ ... }:

/*
  this nixpkgs overlay bumps pywalfox to the latest rc,
  2.8.0rc1. This is so that it better handles nix store
  and the librewolf browser.

  See: https://github.com/NixOS/nixpkgs/issues/281377
  See: https://github.com/Frewacom/pywalfox/issues/68
*/

{
  nixpkgs.overlays = [
    (final: prev: {
      pywalfox-native = prev.python3.pkgs.buildPythonApplication {
        pname = "pywalfox-native";
        version = "2.8.0rc1";

        src = prev.fetchurl {
          url = "https://test-files.pythonhosted.org/packages/89/a1/8e011e2d325de8e987f7c0a67222448b252fc894634bfa0d3b3728ec6dbf/pywalfox-2.8.0rc1.tar.gz";
          sha256 = "89e0d7a441eb600933440c713cddbfaecda236bde7f3f655db0ec20b0ae12845";
        };
      };
    })
  ];
}
