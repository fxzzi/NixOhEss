{lib, ...}: {
  imports = [
    ./librewolf
    ./chromium
  ];
  options.cfg.apps.browsers.startpage = {
    enable = lib.mkEnableOption "";
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
}
