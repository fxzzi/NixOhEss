{
  kdePackages,
  pins,
}:
kdePackages.qt6ct.overrideAttrs {
  pname = "qt6ct-kde-git";
  version = "0-unstable-${builtins.substring 0 8 pins.qt6ct.revision}";
  src = pins.qt6ct;
}
