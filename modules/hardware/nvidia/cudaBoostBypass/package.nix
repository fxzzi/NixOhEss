{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "cudaBoostBypass";
  version = "0-unstable";

  src = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/Ristovski/c81502f850ba095320353ec2094b14cf/raw/boost_bypass.c";
    sha256 = "sha256-3OPAAsfj2Oq+UB3PHnk5GW6PrhZ+YzQ5bu+H8p/EWlo=";
  };

  unpackPhase = ''
    cp $src boost_bypass.c
  '';

  buildPhase = ''
    mkdir $out
    cc boost_bypass.c -O2 -Wextra -Wall -fPIC -shared -o $out/boost_bypass.so -ldl
  '';

  meta = {
    description = "CUDA performance boost bypass for reduced GPU power consumption during video decode";
    homepage = "https://gist.github.com/Ristovski/c81502f850ba095320353ec2094b14cf";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
