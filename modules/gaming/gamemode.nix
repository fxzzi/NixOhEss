{
  lib,
  config,
  user,
  ...
}: {
  options.cfg.gaming.gamemode.enable = lib.mkEnableOption "gamemode";
  config = lib.mkIf config.cfg.gaming.gamemode.enable {
    programs.gamemode.enable = true;
    users.users.${user} = {
      extraGroups = ["gamemode"];
    };
  };
}
