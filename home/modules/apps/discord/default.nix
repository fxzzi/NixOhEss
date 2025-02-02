{
  pkgs,
  lib,
  config,
  ...
}: {
  options.apps.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables discord and some client mods.";
  };
  config = lib.mkIf config.apps.discord.enable {
    home.packages = with pkgs; [
      (discord-canary.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
