{
  boot.tmp = {
    useTmpfs = true; # /tmp is not on tmpfs by default (why??)
    tmpfsSize = "50%"; # allow it to use x% of your RAM
  };
}
