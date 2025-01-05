{ pkgs, config, npins, lib, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autocd = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    autosuggestion.enable = true;
    initExtra = ''
# Match files beginning with . without explicitly specifying the dot
setopt globdots

# tells zsh to ignore case when completing commands or filenames.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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

# Select the Bash word style so backward-kill-word goes to last / or .
autoload -U select-word-style
select-word-style bash

function paste() {
	local file=''${1:-/dev/stdin}
	local link=$(curl -s --data-binary @"$file" https://paste.rs)
	echo $link
	wl-copy $link
}

# See: https://codeberg.org/dnkl/foot/wiki#user-content-spawning-new-terminal-instances-in-the-current-working-directory
function osc7-pwd() {
		emulate -L zsh # also sets localoptions for us
		setopt extendedglob
		local LC_ALL=C
		printf '\e]7;file://%s%s\e\' $HOST ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
}
function chpwd-osc7-pwd() {
		(( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

if [ -z $WAYLAND_DISPLAY ]; then
	fastfetch -l none
else
	fastfetch
fi
    '';
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        # Run Hyprland
        exec Hyprland
      fi
    '';
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      ignoreAllDups = true;
    };
    localVariables = {
      PROMPT = "%F{yellow}%3~%f $ ";
    };
    shellAliases = {
      grep = "rg";
      cat = "bat";

      # I don't like programs.eza.enableZshIntegration's original 'll' alias
      ll = "eza -la";

      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gb = "git branch";
      gc = "git commit --verbose";
      gcam = "git commit --all --message";
      gd = "git diff";
      gp = "git push";

      wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
      adb = "HOME=${config.xdg.dataHome}/android adb";
      ncm = "ncmpcpp";

      hyprupd = "hyprpm update; hyprpm reload -n";

      die = "pkill -9";
      sudo = "sudo ";

      nixos-rebuild = "sudo nixos-rebuild --flake $XDG_CONFIG_HOME/nixos";
      flakeupd = "sudo nix flake update --flake $XDG_CONFIG_HOME/nixos";
    };
    plugins = [
      {
        name = "zsh-completions";
        src = npins.zsh-completions;
      }
      {
        name = "nix-zsh-completions";
        src = npins.nix-zsh-completions;
      }
      {
        name = "fzf-tab";
        src = npins.fzf-tab;
      }
      {
        name = "zsh-fzf-history-search";
        src = npins.zsh-fzf-history-search;
      }
    ];
  };
  programs.eza = {
    enable = true;
    icons = "always";
    colors = "always";
    extraOptions = [ "--group-directories-first" ];
    enableZshIntegration = true;
  };
	programs.ripgrep.enable = true;
	programs.bat.enable = true;
}
