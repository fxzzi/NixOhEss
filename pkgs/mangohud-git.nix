{
  mangohud,
  pins,
}: let
  newMangohud = mangohud.overrideAttrs {
    version = "0-unstable-${builtins.substring 0 8 pins.MangoHud.revision}";
    src = pins.MangoHud;
  };
in
  newMangohud.override (oldAttrs: {
    mangohud32 = oldAttrs.mangohud32.overrideAttrs {
      version = "0-unstable-${builtins.substring 0 8 pins.MangoHud.revision}";
      src = pins.MangoHud;
    };
  })
