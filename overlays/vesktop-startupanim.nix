{npins, ...}: {
  nixpkgs.overlays = [
    (_final: prev: {
      vesktop = prev.vesktop.overrideAttrs (_old: {
        src = npins.Vesktop;
      });
    })
  ];
}
