{ pkgs, inputs, ... }: {
  programs.tack = {
    enable = true;
    package = inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default;
    nixConfTokens = true;
  };
}
