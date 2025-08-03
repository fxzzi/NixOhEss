{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (builtins) filter;
  inherit (lib.attrsets) mapAttrsToList hasAttr;
  inherit (lib.strings) concatStringsSep optionalString;
  cfg = config.cfg.programs.zsh;

  mkPlugins = plugins:
    concatStringsSep "\n" (
      mapAttrsToList (
        _: value: let
          hasFile = hasAttr "file" value;
        in
          concatStringsSep "\n" (
            filter (s: s != "") [
              (optionalString (!hasFile) "fpath+=${value.src}")
              (optionalString (hasFile && value.file != null) ''
                if [[ -f "${value.src}/${value.file}" ]]; then
                  source "${value.src}/${value.file}"
                fi
              '')
            ]
          )
      )
      plugins
    );

  plugins = {
    zsh-completions = {
      name = "zsh-completions";
      src = "${pkgs.zsh-completions}/share/zsh/site-functions";
    };

    nix-zsh-completions = {
      name = "nix-zsh-completions";
      src = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
      file = "nix-zsh-completions.plugin.zsh";
    };

    zsh-syntax-highlighting = {
      name = "zsh-syntax-highlighting";
      src = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
      file = "zsh-syntax-highlighting.zsh";
    };

    fzf-tab = {
      name = "fzf-tab";
      src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      file = "fzf-tab.plugin.zsh";
    };
    zsh-fzf-history-search = {
      name = "zsh-fzf-history-search";
      src = "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search";
      file = "zsh-fzf-history-search.plugin.zsh";
    };

    zsh-autosuggestions = {
      name = "zsh-autosuggestions";
      src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
      file = "zsh-autosuggestions.zsh";
    };

    zsh-history-substring-search = {
      name = "zsh-history-substring-search";
      src = "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search";
      file = "zsh-history-substring-search.zsh";
    };
  };
in {
  options.cfg.programs.zsh.enable = mkEnableOption "zsh";
  config = mkIf cfg.enable {
    users.users.${config.cfg.core.username} = {
      shell = pkgs.zsh; # Set shell to zsh
    };
    hj = {
      packages = with pkgs; [
        fzf
        ripgrep
        bat
        eza
      ];
      files = {
        # empty .zshrc to stop the zsh-newuser stuff
        ".config/zsh/.zshrc".text = "# this is an empty file :D";
      };
    };
    # de-clutter $HOME
    environment.sessionVariables = {
      ZDOTDIR = "\"$HOME\"/.config/zsh";
    };
    programs = {
      zsh = {
        enable = true;
        setOptions = [
          # cd without explicit `cd`
          "AUTOCD"
          # match files beginning with . without explicitly specifying the dot
          "GLOBDOTS"
          # history options to ignore dups and stuff
          "EXTENDED_HISTORY"
          "HIST_EXPIRE_DUPS_FIRST"
          "HIST_IGNORE_DUPS"
          "HIST_IGNORE_ALL_DUPS"
          "HIST_FIND_NO_DUPS"
          "HIST_SAVE_NO_DUPS"
          "HIST_IGNORE_SPACE"

          # make all opened shells share history
          "SHARE_HISTORY"
        ];

        promptInit =
          # sh
          ''
            function precmd() {
              local indicators=""
              [[ -n $IN_NIX_SHELL ]] && indicators+="%F{blue} %f "
              PROMPT="$indicators%F{yellow}%3~%f "
            }
          '';

        interactiveShellInit =
          # sh
          ''
            # Define key bindings
            # Move cursor to beginning and end of line
            bindkey "\e[5~" beginning-of-line # Page Up
            bindkey "\e[6~" end-of-line # Page Down
            # Delete characters and words
            bindkey "^[[3~" delete-char # DEL
            bindkey '^H' backward-kill-word # Ctrl+Backspace (delete word backwards)
            bindkey '^[[3;5~' kill-word # Ctrl+Delete (delete word forwards)
            # Move cursor forward and backward one word at a time
            bindkey "^[[1;5C" forward-word # CTRL+ARROW_RIGHT
            bindkey "^[[1;5D" backward-word # CTRL+ARROW_LEFT
            # Undo and redo changes
            bindkey "^Z" undo # CTRL+Z
            bindkey "^Y" redo # CTRL+Y

            # tells zsh to ignore case when completing commands or filenames.
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

            # Select the Bash word style so backward-kill-word goes to last / or .
            autoload -U select-word-style
            select-word-style bash

            # `paste` command which allows you to upload text to a pastebin
            # usage: paste <file> or <command> | paste
            function paste() {
              local file=''${1:-/dev/stdin}
              local link=$(curl -s --data-binary @"$file" https://paste.rs)
              echo $link
              wl-copy $link
            }


            ${mkPlugins plugins}

            # these keybinds have to be set after the plugin
            bindkey "^[[A" history-substring-search-up
            bindkey "^[[B" history-substring-substring-search-down
            bindkey "^[OA" history-substring-search-up
            bindkey "^[OB" history-substring-search-down
          '';
        histFile = "$HOME/.local/share/zsh/zsh_history";
        histSize = 10000;
        shellAliases = {
          grep = "${getExe pkgs.ripgrep}";
          cat = "${getExe pkgs.bat}";

          ls = "${getExe pkgs.eza} --icons --group-directories-first";
          la = "ls -a";
          ll = "ls -lah";

          lt = "${getExe pkgs.eza} --icons --tree";

          wget = "wget --hsts-file=$HOME/.local/share/wget-hsts";

          die = "pkill -9";
          sudo = "sudo ";
        };
      };
    };
  };
}
