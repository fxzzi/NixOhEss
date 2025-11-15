{
  lib,
  SDL2,
  sdl3,
  alsa-lib,
  appimageTools,
  autoPatchelfHook,
  ffmpeg_4,
  fetchurl,
  icu,
  libkrb5,
  lttng-ust,
  makeWrapper,
  numactl,
  openssl,
  stdenvNoCC,
  symlinkJoin,
  vulkan-loader,
  pipewire_latency ? "64/44100", # reasonable default
  releaseStream ? "lazer",
  command_prefix ? null,
  callPackage,
  pins,
}: let
  pname = "osu-lazer-bin";
  info = (builtins.fromJSON (builtins.readFile "${pins.nix-gaming}/pkgs/osu-lazer-bin/info.json")).${releaseStream};
  inherit (info) version;
  osu-mime = callPackage "${pins.nix-gaming}/pkgs/osu-mime" {};

  appimageBin = fetchurl {
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
    inherit (info) hash;
  };
  extracted = appimageTools.extract {
    inherit version;
    pname = "osu.AppImage";
    src = appimageBin;
  };
  derivation = stdenvNoCC.mkDerivation rec {
    inherit version pname;
    src = extracted;
    buildInputs = [
      SDL2
      sdl3
      alsa-lib
      ffmpeg_4
      icu
      libkrb5
      lttng-ust
      numactl
      openssl
      vulkan-loader
    ];
    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];
    autoPatchelfIgnoreMissingDeps = true;
    installPhase = ''
      runHook preInstall
      install -d $out/bin $out/lib
      install osu.png $out/osu.png
      cp -r usr/bin $out/lib/osu
      makeWrapper $out/lib/osu/osu\! $out/bin/osu\! \
        --set PIPEWIRE_LATENCY "${pipewire_latency}" \
        --set OSU_EXTERNAL_UPDATE_PROVIDER "1" \
        --set OSU_EXTERNAL_UPDATE_STREAM "${releaseStream}" \
        --set vblank_mode "0" \
        --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"

      ${
        # a hack to infiltrate the command in the wrapper
        lib.optionalString (builtins.isString command_prefix) ''
          sed -i '$s:exec -a "$0":exec ${command_prefix}:' $out/bin/osu!
        ''
      }

      install -m 444 -D ${extracted}/osu!.desktop $out/share/applications/osu-lazer.desktop
      for i in 16 32 48 64 96 128 256 512 1024; do
        install -D ${extracted}/osu.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
      done

      runHook postInstall
    '';
    fixupPhase = ''
      runHook preFixup
      ln -sft $out/lib/osu ${SDL2}/lib/libSDL2${stdenvNoCC.hostPlatform.extensions.sharedLibrary}
      ln -sft $out/lib/osu ${sdl3}/lib/libSDL3${stdenvNoCC.hostPlatform.extensions.sharedLibrary}
      runHook postFixup
    '';
  };
in
  symlinkJoin {
    name = "${pname}-${version}";
    paths = [
      derivation
      osu-mime
    ];

    meta = {
      description = "Rhythm is just a *click* away";
      longDescription = "osu-lazer extracted from the official AppImage to retain multiplayer support.";
      homepage = "https://osu.ppy.sh";
      license = with lib.licenses; [
        mit
        cc-by-nc-40
        unfreeRedistributable # osu-framework contains libbass.so in repository
      ];
      mainProgram = "osu-lazer";
      platforms = ["x86_64-linux"];
    };
  }
