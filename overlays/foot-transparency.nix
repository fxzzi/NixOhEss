{ lib, npins, ... }:

/* this nixpkgs overlay replaces foot with my fork,
   which features a few more options for transparency

   See: https://codeberg.org/fazzi/foot/src/branch/transparency_yipee
*/

{
  nixpkgs.overlays = [
    (final: prev: {
      foot = prev.foot.overrideAttrs (old: {
        pname = "foot-transparency";
        src = npins.foot;

        meta = {
          description =
            "A fork of foot - the fast wayland terminal emulator - now with more transparency options!!";
          mainProgram = "foot";
          maintainers = with lib.maintainers; [ Fazzi ];
        };
      });
    })
  ];
}
