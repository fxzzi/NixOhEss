{config, ...}: {
  config = {
    programs.bash.shellInit = ''
      # declutter ~
      export HISTFILE="${config.hj.xdg.stateDirectory}/bash_history"
    '';
  };
}
