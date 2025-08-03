{...}: {
  config = {
    programs.bash.shellInit = ''
      # declutter ~
      export HISTFILE="$HOME/.local/state/bash_history"
    '';
  };
}
