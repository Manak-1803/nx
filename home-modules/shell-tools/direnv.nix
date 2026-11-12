{
  flake.modules.homeManager.shell-tools =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.shell-tools;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          enableGitIntegration = true;
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.dataHome}/direnv" ];
      };
    };
}
