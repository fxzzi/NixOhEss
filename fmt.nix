{
  lib,
  writeShellApplication,
  nixfmt,
  deadnix,
  statix,
  fd,
  biome,
  stylua,
}:
let
  exclusionList = [
    "**/.tack/*"
  ];

  excludeArgs = lib.concatMapStringsSep " " (
    pattern: "--exclude ${lib.escapeShellArg pattern}"
  ) exclusionList;

  fdNix = ''fd "$@" ${excludeArgs} -t f -e nix'';
in
writeShellApplication {
  name = "nix-formatter";

  runtimeInputs = [
    nixfmt
    deadnix
    statix
    fd
    biome
    stylua
  ];

  text = ''
    # statix only takes one file at a time, so run it per file (in parallel).
    # deadnix and nixfmt take many files, so batch them into single calls.
    ${fdNix} -x statix fix --
    ${fdNix} -X deadnix -e --
    ${fdNix} -X nixfmt
    fd "$@" ${excludeArgs} -t f -e js -X biome format --write --indent-style=space --indent-width=2
    fd "$@" ${excludeArgs} -t f -e lua -X stylua --indent-type Spaces --indent-width 2
  '';
}
