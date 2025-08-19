{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "ioshelfka-term";
  version = "0.1.3";

  src = fetchzip {
    url = "https://github.com/NotAShelf/Ioshelfka/releases/download/v${version}/IoshelfkaTerm.zip";
    sha256 = "sha256-4lgchtKzv+P8ZSX4AGdc9pdGaUt4aU+mGm+QmwoJ4qE=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r * $out/share/fonts/
  '';

  meta = with lib; {
    description = "Home-baked Iosevka builds";
    homepage = "https://github.com/NotAShelf/Ioshelfka";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
