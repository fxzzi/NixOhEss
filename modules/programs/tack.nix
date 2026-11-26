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
      package = inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default;
      nixConfTokens = true;
    };
  };
}
