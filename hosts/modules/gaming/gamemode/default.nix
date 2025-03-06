{
  lib,
  config,
  user,
  ...
}: {
  options.cfg.gaming.gamemode.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables gamemode.";
  };
  config = lib.mkIf config.cfg.gaming.gamemode.enable {
    programs.gamemode.enable = true;
    users.users.${user} = {
      extraGroups = ["gamemode"];
    };
  };
}
