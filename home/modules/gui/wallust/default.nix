{
  pkgs,
  lib,
  config,
  ...
}: {
  options.gui.wallust.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables wallust and its configs.";
  };
  config = lib.mkIf config.gui.wallust.enable {
    home.packages = with pkgs; [
      wallust
    ];
    xdg.configFile."wallust".source = "${./wallust}";
  };
}
