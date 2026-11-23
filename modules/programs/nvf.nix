{
  inputs,
  config,
  lib,
  hostName,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.nvf;
  flake = ''(builtins.getFlake "${config.programs.nh.flake}")'';
in
{
  options.cfg.programs.nvf.enable = mkEnableOption "nvf";
  imports = [ inputs.nvf.nixosModules.default ];
  config = mkIf cfg.enable {
    environment.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim -n --cmd 'set laststatus=0 nonumber noruler noshowcmd' +Man!";
      # clanker always ruining my clean ~
      COPILOT_HOME = "$HOME/.config/copilot";
    };
    xdg.mime.defaultApplications = {
      "text/*" = "nvim.desktop";
    };
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          # core
          options = {
            tabstop = 2;
            shiftwidth = 2;
          };
          undoFile.enable = true; # multi-session undo
          enableLuaLoader = true;
          clipboard = {
            enable = true;
            providers.wl-copy.enable = true;
            registers = "unnamedplus";
          };
          luaConfigRC.popup-menu = ''
            -- Remove "disable mouse" entries from the context menu
            vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
            vim.cmd.aunmenu("PopUp.-2-")
          '';

          # lsp
          lsp = {
            enable = true;
            formatOnSave = true;
            trouble.enable = true;
            lspSignature.enable = true;
            servers.nixd.settings.nixd = {
              nixpkgs.expr = "${flake}.nixosConfigurations.${hostName}.pkgs";
              options.nixos.expr = "${flake}.nixosConfigurations.${hostName}.options";
            };
          };
          ui.fastaction.enable = true; # code actions

          # languages
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            bash.enable = true;
            clang.enable = true;
            css.enable = true;
            html.enable = true;
            lua.enable = true;
            markdown = {
              enable = true;
              extensions.render-markdown-nvim.enable = true;
            };
            nix = {
              enable = true;
              format.type = [ "nixfmt" ];
              lsp.servers = [ "nixd" ];
            };
            python.enable = true;
            toml.enable = true;
            typescript = {
              enable = true;
              format.type = [ "biome" ];
            };
            typst.enable = true;
            yaml.enable = true;
          };

          # completion & editing
          autocomplete.nvim-cmp.enable = true;
          snippets.luasnip.enable = true;
          assistant.copilot = {
            enable = true;
            cmp.enable = true;
          };
          autopairs.nvim-autopairs.enable = true;
          comments.comment-nvim.enable = true;
          utility.motion.leap.enable = true;

          # navigation
          telescope.enable = true;
          filetree.neo-tree.enable = true;
          tabline.nvimBufferline.enable = true;
          binds.whichKey.enable = true;

          # git
          git.enable = true;
          utility.diffview-nvim.enable = true;
          terminal.toggleterm = {
            enable = true;
            lazygit.enable = true;
          };

          # looks
          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
            transparent = true;
          };
          statusline.lualine = {
            enable = true;
            integrations.breadcrumbs.navbuddy.enable = true;
          };
          visuals = {
            nvim-web-devicons.enable = true;
            fidget-nvim.enable = true;
            highlight-undo.enable = true;
            indent-blankline.enable = true;
          };
          ui = {
            noice.enable = true;
            colorizer.enable = true;
            illuminate.enable = true;
          };
          notes.todo-comments.enable = true;
          utility.icon-picker.enable = true;
        };
      };
    };
  };
}
