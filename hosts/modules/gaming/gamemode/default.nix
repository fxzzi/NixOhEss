{ lib, config, ... }:
{
	options.gaming.gamemode.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables gamemode.";
  };
  config = lib.mkIf config.gaming.gamemode.enable {
		programs.gamemode.enable = true;
  };
}
