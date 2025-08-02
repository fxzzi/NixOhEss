{
  lib,
  config,
  npins,
  ... 
}: {
  options.cfg.programs.startpage = {
    enable = lib.mkEnableOption "startpage";
    user = lib.mkOption {
      type = lib.types.enum [
        "fazzi"
        "sam"
        "kunzooz"
        "aryan"
      ];
      default = "fazzi";
      description = "Selects which startpage user to use.";
    };
  };
  config = lib.mkIf config.cfg.programs.startpage.enable {
    hj.files.".local/share/startpage".source = npins.startpage; # startpage
  };
}
