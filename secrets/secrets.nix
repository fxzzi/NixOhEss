let
  fazziPC = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5nYcFyV3319s+34IMUDTu8g04H0yjPHQwmhIOKI1GD root@fazziPC";
  faaris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhE7wYZ6juPg1uPs8hTJJMjzWVlMB4maX2K7rE9X84I faaris";
  kunzoz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIrsRN7pAhabnFZfBZC8xxGbqS+hjGDGKlPSDujEHXw+ kunzoz@kunzozPC";
in
{
  "publicip.age".publicKeys = [ fazziPC ];
  # monitor icc profile from Monitors Unboxed
  "mub-M27Q_v1.icm.age".publicKeys = [ fazziPC ];
  "nix-access-tokens.age".publicKeys = [
    faaris
    kunzoz
  ];
  "ssh/github.age".publicKeys = [ faaris ];
  "ssh/gitlab.age".publicKeys = [ faaris ];
  "ssh/codeberg.age".publicKeys = [ faaris ];
  "ssh/rafgit.age".publicKeys = [ faaris ];
  "ssh/aur.age".publicKeys = [ faaris ];
  "ssh/archlinux-gitlab.age".publicKeys = [ faaris ];
}
