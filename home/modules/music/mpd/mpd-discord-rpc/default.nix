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
      package = pkgs.mpd-discord-rpc.overrideAttrs (
        finalAttrs: _: {
          src = npins.mpd-discord-rpc;

          cargoDeps = pkgs.rustPackages.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) src;
            hash = "sha256-rXiE6iYHP+m6y80glaRhQZx3xp4U8fgZIVpp/OttVks=";
          };
        }
      );

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
