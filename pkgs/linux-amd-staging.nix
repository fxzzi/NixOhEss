{
  lib,
  buildLinux,
  pins,
  ...
} @ args:
buildLinux (args
  // rec {
    pname = "linux-amd-staging";
    version = "6.19.0";

    extraMeta.branch = lib.versions.majorMinor version;

    modDirVersion = "6.19.0";

    src = pins.linux-amd-staging;

    # Don't build on Hydra
    extraMeta.hydraPlatforms = [];
  }
  // (args.argsOverride or {}))
