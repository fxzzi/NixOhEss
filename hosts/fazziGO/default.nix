{ ... }:
{
  networking.hostName = "fazziGO";
  imports = [
    ../global
    ./networking
  ];
}
