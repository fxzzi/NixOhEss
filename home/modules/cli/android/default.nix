{
  pkgs,
  config,
  lib,
  ...
}: {
  options.cli.android.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Adds a few packages like scrcpy and paylod dumper.";
  };
  config = lib.mkIf config.cli.android.enable {
    home.packages = with pkgs; [
      scrcpy
      payload-dumper-go
    ];
  };
}
