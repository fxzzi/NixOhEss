{
  mangohud,
  pins,
}: let
  common = {
    pname = "mangohud-git";
    version = "0-unstable-${builtins.substring 0 8 pins.MangoHud.revision}";
    src = pins.MangoHud;
  };
in
  (mangohud.overrideAttrs common).override (old: {
    mangohud32 = old.mangohud32.overrideAttrs common;
  })
