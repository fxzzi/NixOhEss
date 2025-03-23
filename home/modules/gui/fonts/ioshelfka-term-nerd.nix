{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "ioshelfka-term-nerd";
  version = "0.1.3";

  src = fetchzip {
    url = "https://github.com/NotAShelf/Ioshelfka/releases/download/v${version}/IoshelfkaTermNerd.zip";
    sha256 = "sha256-002uoBL93A0sWyzxxFqeUbSOyDzuHeDddXEqfyYMTls=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r * $out/share/fonts/
  '';

  meta = with lib; {
    description = "Home-baked Iosevka builds, with Nix.";
    homepage = "https://github.com/NotAShelf/Ioshelfka";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
