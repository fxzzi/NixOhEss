{
  callPackage,
  fetchFromGitea,
  npins,
}: {
  eden = callPackage ./generic.nix (
    let
      pin = npins.eden;
    in {
      forkName = "eden";
      inherit (pin) version;
      source = fetchFromGitea {
        domain = "git.eden-emu.dev";
        owner = "eden-emu";
        repo = "eden";
        tag = pin.version;
        sha256 = pin.hash;
        fetchSubmodules = true;
      };
      homepage = "https://git.eden-emu.dev/eden-emu/eden/releases";
      mainProgram = "eden";
    }
  );
}
