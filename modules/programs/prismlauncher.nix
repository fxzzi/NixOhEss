{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.programs.prismlauncher;
  ninjabrain-bot = pkgs.fetchurl {
    url = "https://github.com/Ninjabrain1/Ninjabrain-Bot/releases/download/1.5.1/Ninjabrain-Bot-1.5.1.jar";
    sha256 = "sha256-Rxu9A2EiTr69fLBUImRv+RLC2LmosawIDyDPIaRcrdw=";
  };
in {
  options.cfg.programs.prismlauncher = {
    enable = mkEnableOption "prismlauncher";
    waywall.enable = mkEnableOption "Waywall";
  };

  config = mkIf cfg.enable {
    hj.packages = with pkgs; [
      (prismlauncher.override {
        jdks = [
          temurin-jre-bin-8
          temurin-jre-bin-17
          temurin-jre-bin-21
        ];
        # required for mcsr anticheat (fairplay), ninjabrain-bot
        additionalLibs = [
          libxt
          libxtst
          libxkbcommon
          libxinerama
        ];
      })
      (mkIf cfg.waywall.enable waywall)
    ];
    hj.xdg.config.files."waywall/init.lua".text =
      mkIf cfg.waywall.enable
      #lua
      ''
        local waywall = require("waywall")
        local helpers = require("waywall.helpers")
        local config = {
          theme = {
            background = "#303030ff",
            ninb_anchor = {
              position = "bottomleft",
              x = 160,
              y = -90,
            },
          },
          experimental = {
            -- tearing = true,
          },
          input = {
            repeat_rate = 55,
            repeat_delay = 375,
            confine_pointer = true,
          },
        }
        config.actions = {
          ["Ctrl-Shift-N"] = function()
            waywall.exec("${getExe pkgs.temurin-jre-bin-17} -jar ${ninjabrain-bot} -Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel")
          end,
          ["F7"] = function()
            helpers.toggle_floating()
          end
        }

        return config
      '';
  };
}
