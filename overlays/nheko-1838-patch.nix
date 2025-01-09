{pkgs, ...}:
{
  nixpkgs.overlays = [
    (final: prev: {
      nheko = prev.nheko.overrideAttrs (old: {
        patches = pkgs.fetchpatch {
          url = "https://github.com/Nheko-Reborn/nheko/pull/1838.patch";
					hash = "sha256-hYG/nFPTJSRVadt7H4CgefBCwEAKCR7xU5hA5pTzpXU=";
        };
      });
    })
  ];
}
