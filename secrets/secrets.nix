let
  faaris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+Kjr0j3O9d94/ZNyD0vn7hxMQtQkakm1iB2ehBHfmX";
  fazziPC = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHNAU7x3A0Jt4gSiMklxKplU8Y0p8dUYflp4JYtVgfY";
in {
  "publicip.age".publicKeys = [
    faaris
    fazziPC
  ];
}
