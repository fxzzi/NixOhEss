{
  lib,
  stdenvNoCC,
  npins,
  pkgs,
}:
stdenvNoCC.mkDerivation {
  pname = "xdg-terminal-exec";
  version = builtins.replaceStrings ["v"] [""] npins.xdg-terminal-exec.version;

  src = npins.xdg-terminal-exec;

  buildInputs = with pkgs; [
    scdoc
  ];

  buildPhase = ''
    substituteInPlace xdg-terminal-exec \
      --replace "#!/bin/sh" "#!${lib.getExe pkgs.dash}"
  '';

  installPhase = ''
    install -Dt $out/bin xdg-terminal-exec
  '';

  meta = {
    description = "Proposal for XDG Default Terminal Execution Specification and shell-based reference implementation.";
    homepage = "https://github.com/Vladimir-csp/xdg-terminal-exec";
    mainProgram = "xdg-terminal-exec";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
