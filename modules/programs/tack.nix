{ pkgs, inputs, ... }: {
  programs.tack = {
    enable = true;
    package = pkgs.callPackage "${inputs.tack}/nix/package.nix" { };
    nixConfTokens = true;
  };
}
