{
  perSystem = {pkgs, ...}: let
    exclusionList = [
      "**/npins/*"
    ];
    excludeArgs = builtins.concatStringsSep " " (map (pattern: "--exclude '${pattern}'") exclusionList);
  in {
    formatter = pkgs.writeShellApplication {
      name = "nix-formatter";
      runtimeInputs = with pkgs; [
        alejandra
        deadnix
        statix
        fd
      ];
      text = ''
        fd "$@" ${excludeArgs} -t f -e nix -x statix fix -- '{}'
        fd "$@" ${excludeArgs} -t f -e nix -X deadnix -e -- '{}' \; -X alejandra -q '{}'
      '';
    };
  };
}
