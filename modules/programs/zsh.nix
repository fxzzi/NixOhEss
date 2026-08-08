{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.programs.zsh;
in {
  options.cfg.programs.zsh.enable = mkEnableOption "zsh";
  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        enableGlobalCompInit = false; # we add to fpath after
        enableLsColors = false; # we use eza instead :D
        histFile = "$XDG_DATA_HOME/zsh/zsh_history";
        histSize = 10000;
        promptInit = ''PROMPT="%F{yellow}%3~%f $ "'';
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        setOptions = [
          # match files beginning with . without explicitly specifying the dot
          "GLOBDOTS"

          # history options to ignore dups
          "HIST_EXPIRE_DUPS_FIRST"
          "HIST_IGNORE_ALL_DUPS"
          "HIST_FIND_NO_DUPS"
          "HIST_IGNORE_SPACE"

          # share history between open shells
          "SHARE_HISTORY"
          "INC_APPEND_HISTORY"
        ];
        shellAliases = {
          grep = getExe pkgs.ripgrep;
          cat = "${getExe pkgs.bat} -p";

          ls = "${getExe pkgs.eza} --icons --group-directories-first";
          la = "ls -a";
          ll = "ls -lah";

          lt = "${getExe pkgs.eza} --icons --tree";

          # clean up ~
          wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";

          die = "pkill -9";
        };
        shellInit = ''
          # Disable zsh's newuser startup script that prompts you to create
          # a ~/.z* file if missing
          zsh-newuser-install() { :; }
        '';
        interactiveShellInit =
          # sh
          ''
            # Define key bindings
            bindkey -e # Use Emacs keybindings
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

            # ctrl-left/right and ctrl-bspc will limit here
            WORDCHARS='*?_-.[]~=&;!$%^(){}<>|'

            # `paste` command which allows you to upload text to a pastebin
            # usage: `paste <file>` or `<command> | paste`
            function paste() {
              local file=''${1:-/dev/stdin}
              local link=$(curl -s --data-binary @"$file" https://paste.rs)
              echo $link
              wl-copy $link
            }

            # plugins
            source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
            source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
            # these keybinds have to be set after the plugin is sourced
            bindkey "''${key[Up]}" history-substring-search-up
            bindkey "''${key[Down]}" history-substring-search-down

            # completions
            fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
            autoload -U compinit && compinit
          '';
      };
      fzf = {
        fuzzyCompletion = true;
        keybindings = true;
      };
    };
    users.users.${config.cfg.core.username} = {
      shell = pkgs.zsh; # Set shell to zsh
    };
    environment = {
      systemPackages = with pkgs; [
        ripgrep
        bat
        eza
      ];
      sessionVariables = {
        # clean up ~
        ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      };
    };
  };
}
