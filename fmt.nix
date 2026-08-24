{
  lib,
  writeShellApplication,
  alejandra,
  deadnix,
  statix,
  fd,
}:
let
  exclusionList = [
    "**/.tack/*"
  ];

  excludeArgs = lib.concatMapStringsSep " " (
    pattern: "--exclude ${lib.escapeShellArg pattern}"
  ) exclusionList;

  commands = [
    "statix fix -- '{}'"
    "deadnix -e -- '{}'"
    "alejandra -q '{}'"
  ];
in
writeShellApplication {
  name = "nix-formatter";

  runtimeInputs = [
    alejandra
    deadnix
    statix
    fd
  ];

  text = ''
    fd "$@" ${excludeArgs} -t f -e nix -x sh -c ${lib.escapeShellArg (lib.concatStringsSep "; " commands)}
  '';
}
