{
  lib,
  inputs,
}: {
  # retrieve the hyprlang generator directly from hyprland source
  inherit ((import "${inputs.hyprland}/nix/lib.nix" lib)) toHyprlang;
  inherit ((import ./toHyprconf.nix lib)) toHyprconf;
}
