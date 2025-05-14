{user, ...}: {
  config = {
    programs.bash.shellInit = ''
      # declutter ~
      export HISTFILE="/home/${user}/.local/state/bash_history"
    '';
  };
}
