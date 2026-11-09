{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  options.cfg.programs.tack.enable = lib.mkEnableOption "tack";
  config = lib.mkIf config.cfg.programs.tack.enable {
    programs.tack = {
      enable = true;
      package = pkgs.callPackage "${inputs.tack}/nix/package.nix" { };
      nixConfTokens = true;
    };
  };
}
