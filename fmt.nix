{
  lib,
  treefmt,
  nixfmt,
  deadnix,
  statix,
  biome,
  stylua,
}:
treefmt.withConfig {
  settings = {
    tree-root-file = "flake.nix";
    on-unmatched = "info";
    excludes = [ ".tack/**" ];

    formatter = {
      # statix only takes one file at a time
      statix = {
        command = "sh";
        options = [
          "-c"
          ''for f; do ${lib.getExe statix} fix -- "$f"; done''
          "--"
        ];
        includes = [ "*.nix" ];
        priority = 1;
      };

      deadnix = {
        command = lib.getExe deadnix;
        options = [ "-e" ];
        includes = [ "*.nix" ];
        priority = 2;
      };

      nixfmt = {
        command = lib.getExe nixfmt;
        includes = [ "*.nix" ];
        priority = 3;
      };

      biome = {
        command = lib.getExe biome;
        options = [
          "format"
          "--write"
        ];
        includes = [ "*.js" ];
      };

      stylua = {
        command = lib.getExe stylua;
        includes = [ "*.lua" ];
      };
    };
  };
}
