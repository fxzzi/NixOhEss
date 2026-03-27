{
  lib,
  config,
  pins,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.cfg.programs.startpage;
in {
  options.cfg.programs.startpage = {
    enable = mkEnableOption "startpage";
    user = mkOption {
      type = types.enum [
        "fazzi"
        "sam"
        "kunzooz"
        "aryan"
      ];
      default = "fazzi";
      description = "Selects which startpage user to use.";
    };
    page = mkOption {
      type = types.str;
      internal = true;
      default = "file://${config.hj.xdg.data.directory}/startpage/${config.cfg.programs.startpage.user}/index.html";
    };
  };
  config = mkIf cfg.enable {
    hj.xdg.data.files."startpage".source = pins.startpage; # startpage
  };
}
