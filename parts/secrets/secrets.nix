let
  fazziPC = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5nYcFyV3319s+34IMUDTu8g04H0yjPHQwmhIOKI1GD root@fazziPC";
in {
  "publicip.age".publicKeys = [fazziPC];
  # monitor icc profiles from Monitors Unboxed and TFT Central
  "mub-M27Q_v1.icm.age".publicKeys = [fazziPC];
  "tft-gigabyte_m27q.icm.age" .publicKeys = [fazziPC];
  "tft-gigabyte_mo27q28g.icm.age".publicKeys = [fazziPC];
}
