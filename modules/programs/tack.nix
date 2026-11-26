{
  lib,
  config,
  ...
}:
{
  options.cfg.programs.tack.enable = lib.mkEnableOption "tack";
  config = lib.mkIf config.cfg.programs.tack.enable {
    programs.tack = {
      enable = true;
      nixConfTokens = true;
    };
  };
}
