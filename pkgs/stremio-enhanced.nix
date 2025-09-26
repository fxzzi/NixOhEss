{
  appimageTools,
  fetchurl,
}: let
  pname = "stremio-enhanced";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/REVENGE977/stremio-enhanced/releases/download/v${version}/Stremio.Enhanced-${version}.AppImage";
    hash = "sha256-pUKKLHvbCrtTUma1lRM7kT+KYjddawJGiKRHpkCWXvY=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/stremio-enhanced.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    '';
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/stremio-enhanced.desktop $out/share/applications/stremio-enhanced.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/stremio-enhanced.png \
        $out/share/icons/hicolor/512x512/apps/stremio-enhanced.png
    '';
  }
