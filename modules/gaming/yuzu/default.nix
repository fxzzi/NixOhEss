{
  callPackage,
  fetchFromGitea,
  npins,
}: {
  eden = callPackage ./generic.nix (
    let
      pin = npins.eden;
      version = "0-unstable-${builtins.substring 0 8 pin.revision}";
    in {
      forkName = "eden";
      inherit version;
      source = fetchFromGitea {
        domain = "git.eden-emu.dev";
        owner = "eden-emu";
        repo = "eden";
        rev = pin.revision;
        sha256 = pin.hash;
        fetchSubmodules = true;
      };
      homepage = "https://git.eden-emu.dev/eden-emu/eden/releases";
      mainProgram = "eden";
    }
  );
}
