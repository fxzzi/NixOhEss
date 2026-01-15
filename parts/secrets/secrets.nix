let
  fazziPC = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5nYcFyV3319s+34IMUDTu8g04H0yjPHQwmhIOKI1GD root@fazziPC";
in {
  "publicip.age".publicKeys = [fazziPC];
}
