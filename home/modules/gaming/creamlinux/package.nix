{
  pkgs,
  fetchFromGitHub,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "creamlinux";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "Novattz";
    repo = "creamlinux-installer";
    rev = "v${version}";
    sha256 = "sha256-K57tcoLhuXXa56sFWKye5E2xjDZbUPpOApteH7prd8w=";
  };

  propagatedBuildInputs = [
    (pkgs.python3.withPackages (pythonPackages:
      with pythonPackages; [
        requests
        zipfile2
        tqdm
      ]))
  ];

  patchPhase = ''
    # Prepend shebang to the Python script
    sed -i '1i #!/usr/bin/env python3' dlc_fetcher.py
  '';

  installPhase = ''
    install -Dm755 dlc_fetcher.py $out/bin/creamlinux
  '';
}
