{ inputs, ... }: {
  imports = [ inputs.git-hooks-nix.flakeModule ];

  perSystem = { config, ... }: {
    pre-commit.settings = {
      default_stages = [
        "pre-commit"
        "pre-push"
      ];

      hooks = {
        flake-checker.enable = true;

        treefmt = {
          enable = true;
          package = config.treefmt.build.wrapper;
        };
      };
    };
  };
}
