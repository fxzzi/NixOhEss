{
  foot,
  pins,
  fetchFromGitea,
}:
foot.overrideAttrs {
  pname = "foot-transparency";
  version = "0-unstable-${builtins.substring 0 8 pins.foot.revision}";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fazzi";
    repo = "foot";
    rev = pins.foot.revision;
    sha256 = pins.foot.hash;
  };
}
