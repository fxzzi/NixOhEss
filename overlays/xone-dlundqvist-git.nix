{npins, ...}:
/*
this nixpkgs overlay replaces xone with a fork by dlundqvist,
keeping xone up to date and providing a few new features.
See: https://github.com/dlundqvist/xone
*/
{
  nixpkgs.overlays = [
    (_self: super: {
      linuxPackages = super.linuxPackages.extend (_lpself: _lpsuper: {
        xone = super.linuxPackages.xone.overrideAttrs (_oldAttrs: {
          src = npins.xone;
          # patches = [];
        });
      });
    })
  ];
}
