{
  lib,
  config,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
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
  };
  config = lib.mkIf cfg.enable {
    hj.files.".local/share/startpage".source = npins.startpage; # startpage
  };
}
