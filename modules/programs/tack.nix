{ pkgs, inputs, ... }: {
  programs.tack = {
    enable = true;
    package = (pkgs.callPackage "${inputs.tack}/nix/package.nix" { }).overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [
        pkgs.pkg-config
      ];
      buildInputs = oldAttrs.buildInputs or [ ] ++ [
        pkgs.zstd
      ];
    });
    nixConfTokens = true;
  };
}
