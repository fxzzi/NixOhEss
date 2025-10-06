let
  fazziPC = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHNAU7x3A0Jt4gSiMklxKplU8Y0p8dUYflp4JYtVgfY root@fazziPC";
in {
  "publicip.age".publicKeys = [fazziPC];
}
