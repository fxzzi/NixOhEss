{
  config = {
    programs.bash.interactiveShellInit = ''
      HISTFILE="$XDG_STATE_HOME/bash_history"
    '';
  };
}
