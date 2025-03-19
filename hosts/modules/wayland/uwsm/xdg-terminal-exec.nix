{
  lib,
  stdenvNoCC,
  npins,
  pkgs,
}:
stdenvNoCC.mkDerivation {
  pname = "xdg-terminal-exec";
  version = "0-unstable-${npins.xdg-terminal-exec.revision}";

  src = npins.xdg-terminal-exec;

  buildInputs = with pkgs; [
    scdoc
  ];

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
