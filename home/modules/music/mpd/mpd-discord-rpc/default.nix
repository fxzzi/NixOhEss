{
  lib,
  config,
  npins,
  pkgs,
  ...
}: {
  options.music.mpd.discord-rpc.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the mpd rich presence service.";
  };
  config = lib.mkIf config.music.mpd.discord-rpc.enable {
    services.mpd-discord-rpc = {
      enable = true;
      # package = pkgs.mpd-discord-rpc.overrideAttrs (oldAttrs: rec {
      #   pname = "mpd-discord-rpc-git";
      #   src = npins.mpd-discord-rpc;
      #   cargoDeps = oldAttrs.cargoDeps.overrideAttrs {
      #     inherit src;
      #     outputHash = "sha256-uDru6npxi+NU/KzCa8uoGqvLrJwMB+PGWl7rneyubCY=";
      #   };
      # });

      settings = {
        hosts = ["localhost:6600"];
        format = {
          details = "$title";
          state = "$artist";
          timestamp = "elapsed";
          large_image = "notes";
          small_image = "";
          large_text = "$album";
          small_text = "";
        };
      };
    };
  };
}
