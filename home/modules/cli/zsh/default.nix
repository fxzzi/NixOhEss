{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.cli.zsh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the zsh shell.";
  };
  config = {
    programs = {
      zsh = lib.mkIf config.cfg.cli.zsh.enable {
        enable = true;
        dotDir = ".config/zsh";
        autocd = true;
        defaultKeymap = "emacs";
        syntaxHighlighting.enable = true;
        historySubstringSearch.enable = true;
        autosuggestion.enable = true;
        initContent =
          # sh
          lib.mkBefore ''
            if [ -n "$IN_NIX_SHELL" ]; then
                export PROMPT="[nix-shell] %F{yellow}%3~%f $ "
            else
                export PROMPT="%F{yellow}%3~%f $ "
            fi
            # Define key bindings
            bindkey -r '\e'
            bindkey -s '^[[27;2;27~' '~'
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
            # Allow backspace to delete characters across multiple lines like in Vim
            bindkey -v '^?' backward-delete-char

            # Match files beginning with . without explicitly specifying the dot
            setopt globdots

            # tells zsh to ignore case when completing commands or filenames.
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

            # Select the Bash word style so backward-kill-word goes to last / or .
            autoload -U select-word-style
            select-word-style bash

            function paste() {
              local file=''${1:-/dev/stdin}
              local link=$(curl -s --data-binary @"$file" https://paste.rs)
              echo $link
              wl-copy $link
            }

            # for zsh-fzf-history-search
            bindkey '^[[A' history-substring-search-up
            bindkey '^[[B' history-substring-search-down
          '';
        history = {
          path = "${config.xdg.dataHome}/zsh/zsh_history";
          ignoreAllDups = true;
          extended = true;
        };
        localVariables = {
          # PROMPT = "%F{yellow}%3~%f $ ";
        };
        shellAliases = {
          grep = "rg";
          cat = "bat";

          ll = "eza -la";

          wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";

          die = "pkill -9";
          sudo = "sudo ";
        };
        plugins = [
          {
            name = "zsh-completions";
            src = pkgs.zsh-completions;
          }
          {
            name = "nix-zsh-completions";
            src = pkgs.nix-zsh-completions;
          }
          {
            name = "fzf-tab";
            src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
          }
          {
            name = "zsh-fzf-history-search";
            src = pkgs.zsh-fzf-history-search;
          }
          {
            name = "nix-shell";
            src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
          }
        ];
      };
      eza = {
        enable = true;
        icons = "always";
        colors = "always";
        extraOptions = ["--group-directories-first"];
        enableZshIntegration = true;
      };
      ripgrep.enable = true;
      bat.enable = true;
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
