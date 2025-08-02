{
  lib,
  config,
  npins,
  ...
}: {
  imports = [
    ./librewolf.nix
    ./chromium
  ];
  options.cfg.programs.browsers.startpage = {
    enable = lib.mkEnableOption "browsers";
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
  config = lib.mkIf config.cfg.programs.browsers.startpage.enable {
    hj.files.".local/share/startpage".source = npins.startpage; # startpage
  };
}
