{
  config,
  lib,
  user,
  ...
}: {
  options.cfg.adb.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Configures ADB debugging";
  };
  config = lib.mkIf config.cfg.adb.enable {
    programs.adb.enable = true;
    users.users.${user} = {
      extraGroups = ["adbusers"];
    };
  };
}
