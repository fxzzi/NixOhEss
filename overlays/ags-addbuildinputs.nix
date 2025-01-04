{ pkgs, ... }:

/*  
this nixpkgs overlay adds the buildinput `libdbusmenu-gtk3`
to make the tray module work correctly in ags. See:

https://github.com/NixOS/nixpkgs/issues/306446
*/


{
  nixpkgs.overlays = [
    (final: prev:
      {
        ags = prev.ags.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
        });
      })
  ];
}
