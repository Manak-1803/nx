{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    programs = {
      nixfmt.enable = true;
      statix.enable = true;
      nixf-diagnose.enable = true;

      actionlint.enable = true;
      prettier.enable = true;
    };
  };
}
