{
  callPackage,
  fetchFromGitea,
}: {
  eden = callPackage ./generic.nix (
    let
      revision = "321bb5a17f17739f554078261c7f86e58e2f89bc";
      version = "0-unstable-${revision}";
    in {
      forkName = "eden";
      inherit version;
      source = fetchFromGitea {
        domain = "git.eden-emu.dev";
        owner = "eden-emu";
        repo = "eden";
        rev = revision;
        hash = "sha256-s4fZFlNc9/tyn0b+4pTEfwRTsmEzZv4C5/Lraygvk9A=";
        fetchSubmodules = true;
      };

      homepage = "https://git.eden-emu.dev/eden-emu/eden/releases";
      mainProgram = "eden";
    }
  );
}
