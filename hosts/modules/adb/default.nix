{
  config,
  lib,
  ...
}: {
  options.adb.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Configures ADB debugging";
  };
  config = lib.mkIf config.adb.enable {
    programs.adb.enable = true;
  };
}
