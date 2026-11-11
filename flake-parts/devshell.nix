{ lib, ... }: {
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          nixfmt

          age
          sops
          ssh-to-age
          age-plugin-tpm

          local.hash-ip
        ];

        shellHook = lib.concatStringsSep "\n" [
          config.pre-commit.shellHook
        ];
      };
    };
}
