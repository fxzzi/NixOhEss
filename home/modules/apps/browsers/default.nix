{lib, ...}: {
  imports = [
    ./librewolf
    ./chromium
  ];
  options.cfg.apps.browsers.startpage = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the custom startpage on supported browsers (chromium, librewolf)";
    };
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
