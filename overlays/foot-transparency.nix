{ pkgs, lib, npins, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # replace foot with foot-transparency
      foot = prev.foot.overrideAttrs (old: {
        pname = "foot-transparency";
        src = npins.foot;

        meta = {
          description = "A fork of foot - the fast wayland terminal emulator - now with more transparency options!!";
          mainProgram = "foot";
          maintainers = with lib.maintainers; [ Fazzi ];
        };
      });
    })
  ];
}
