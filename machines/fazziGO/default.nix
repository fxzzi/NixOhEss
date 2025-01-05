{ ... }:
{
	config.networking.hostname = "fazziGO";
  imports = [
		../global
    ./networking
  ];
}
