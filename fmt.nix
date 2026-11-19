{
  lib,
  writeShellApplication,
  nixfmt,
  deadnix,
  statix,
  fd,
  prettier,
  stylua,
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
    "nixfmt '{}'"
  ];
in
writeShellApplication {
  name = "nix-formatter";

  runtimeInputs = [
    nixfmt
    deadnix
    statix
    fd
    prettier
    stylua
  ];

  text = ''
    fd "$@" ${excludeArgs} -t f -e nix -x sh -c ${lib.escapeShellArg (lib.concatStringsSep "; " commands)}
    fd "$@" ${excludeArgs} -t f -e js -X prettier --write --log-level warn
    fd "$@" ${excludeArgs} -t f -e lua -X stylua
  '';
}
