let
  faaris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhE7wYZ6juPg1uPs8hTJJMjzWVlMB4maX2K7rE9X84I";
in {
  "publicip.age".publicKeys = [faaris];
}
