{ npins, lib, pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      gamescope = prev.gamescope.overrideAttrs (old: {
				src = pkgs.fetchFromGitHub {
					owner = npins.gamescope.repository.owner;
					repo = npins.gamescope.repository.repo;
					rev = npins.gamescope.revision;
					hash = "sha256-6EknLsQ+q4gM4sWDyT1X1CUCwyXMfW4LI9H5/7Ba8hg=";
					fetchSubmodules = true;
				};
      });
    })
  ];
}
