{
  lib,
  stdenvNoCC,
  dash,
  npins,
}:
stdenvNoCC.mkDerivation {
  pname = "app2unit";
  version = "0-unstable-${builtins.substring 0 8 npins.app2unit.revision}";

  src = npins.app2unit;

  installPhase = ''
    install -Dt $out/bin app2unit
    ln -s $out/bin/app2unit $out/bin/app2unit-open
  '';

  dontPatchShebangs = true;
  postFixup = ''
    substituteInPlace $out/bin/app2unit \
      --replace-fail '#!/bin/sh' '#!${lib.getExe dash}'
  '';

  meta = {
    description = "Launches Desktop Entries as Systemd user units";
    homepage = "https://github.com/Vladimir-csp/app2unit";
    license = lib.licenses.gpl3;
    mainProgram = "app2unit";
    maintainers = with lib.maintainers; [fazzi];
    platforms = lib.platforms.linux;
  };
}
