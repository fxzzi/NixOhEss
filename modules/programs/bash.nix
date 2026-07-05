_: {
  config = {
    programs.bash.shellInit = ''
      # declutter ~
      export HISTFILE="$XDG_STATE_HOME/bash_history"
    '';
  };
}
