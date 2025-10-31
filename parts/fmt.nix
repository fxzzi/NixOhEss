_: {
  perSystem = {config, ...}: {
    # alejandra and co. for formatting
    formatter = config.packages.alejFmt;
  };
}
