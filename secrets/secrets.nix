let
  fazziPC = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9kmPRt5qQQdurXf3bS8USO1CQbfY7JYkbJXKgkTHmc root@fazziPC";
in {
  "publicip.age".publicKeys = [fazziPC];
}
