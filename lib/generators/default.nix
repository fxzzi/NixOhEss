lib: {
  inherit ((import ./toHyprlang.nix lib)) toHyprlang;
  inherit ((import ./toHyprconf.nix lib)) toHyprconf;
}
