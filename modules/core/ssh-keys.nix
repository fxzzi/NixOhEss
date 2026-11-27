{ lib, config, ... }:
let
  inherit (lib) mkIf listToAttrs;
  inherit (config.cfg.core) username;
  inherit (config.hj) directory;

  keys = [
    "github"
    "gitlab"
    "codeberg"
    "rafgit"
    "aur"
    "archlinux-gitlab"
  ];
in
mkIf (username == "faaris") {
  age.secrets = listToAttrs (
    map (key: {
      name = "ssh-${key}";
      value = {
        file = ../../secrets/ssh/${key}.age;
        path = "${directory}/.ssh/${key}";
        # ssh refuses private keys readable by anyone else
        owner = username;
        group = "users";
        mode = "600";
      };
    }) keys
  );
  hj.files = listToAttrs (
    map (key: {
      name = ".ssh/${key}.pub";
      value.source = ../../secrets/ssh/${key}.pub;
    }) keys
  );
}
