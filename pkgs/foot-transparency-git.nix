{
  foot,
  pins,
  fetchFromGitea,
  fetchpatch2,
}:
foot.overrideAttrs (oldAttrs: {
  pname = "foot-transparency-git";
  version = "0-unstable-${builtins.substring 0 8 pins.foot.revision}";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "foot";
    rev = pins.foot.revision;
    sha256 = pins.foot.hash;
  };
  patches =
    oldAttrs.patches or []
    ++ [
      (fetchpatch2 {
        url = "https://codeberg.org/fazzi/foot/pulls/2.patch";
        hash = "sha256-biXxp3G/vPpEBFmUBysPmZPsOpSPQFp9CVnKafq6O+Q=";
      })
    ];
})
