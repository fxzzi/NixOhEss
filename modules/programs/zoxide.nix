{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.zoxide;
in
{
  options.cfg.programs.zoxide.enable = mkEnableOption "zoxide";
  config.programs.zoxide = mkIf cfg.enable {
    enable = true;
    flags = [ "--cmd cd" ];
  };
}
