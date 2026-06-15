{
  writeShellApplication,
  alejandra,
  deadnix,
  statix,
  fd,
}: let
  exclusionList = [
    "**/.tack/*"
  ];
  excludeArgs = builtins.concatStringsSep " " (map (pattern: "--exclude '${pattern}'") exclusionList);
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
      fd "$@" ${excludeArgs} -t f -e nix -x statix fix -- '{}'
      fd "$@" ${excludeArgs} -t f -e nix -X deadnix -e -- '{}' \; -X alejandra -q '{}'
    '';
  }
