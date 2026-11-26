{ lib, config, ... }:
let
  ssh = "${config.hj.directory}/.ssh";

  # ssh refuses private keys readable by anyone else
  privateKey = {
    owner = config.cfg.core.username;
    group = "users";
    mode = "600";
    symlink = false;
  };
in
lib.mkIf (config.cfg.core.username == "faaris") {
  age.secrets = {
    ssh-github = privateKey // {
      file = ../../secrets/ssh/github.age;
      path = "${ssh}/github";
    };
    ssh-gitlab = privateKey // {
      file = ../../secrets/ssh/gitlab.age;
      path = "${ssh}/gitlab";
    };
    ssh-codeberg = privateKey // {
      file = ../../secrets/ssh/codeberg.age;
      path = "${ssh}/codeberg";
    };
    ssh-rafgit = privateKey // {
      file = ../../secrets/ssh/rafgit.age;
      path = "${ssh}/rafgit";
    };
    ssh-aur = privateKey // {
      file = ../../secrets/ssh/aur.age;
      path = "${ssh}/aur";
    };
    ssh-archlinux-gitlab = privateKey // {
      file = ../../secrets/ssh/archlinux-gitlab.age;
      path = "${ssh}/archlinux-gitlab";
    };
  };
  hj.files = {
    ".ssh/github.pub".source = ../../secrets/ssh/github.pub;
    ".ssh/gitlab.pub".source = ../../secrets/ssh/gitlab.pub;
    ".ssh/codeberg.pub".source = ../../secrets/ssh/codeberg.pub;
    ".ssh/rafgit.pub".source = ../../secrets/ssh/rafgit.pub;
    ".ssh/aur.pub".source = ../../secrets/ssh/aur.pub;
    ".ssh/archlinux-gitlab.pub".source = ../../secrets/ssh/archlinux-gitlab.pub;
  };
}
