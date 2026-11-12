{
  flake.modules.homeManager.shell-tools =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.shell-tools;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.eza = {
          enable = true;
          git = true;
          icons = "auto";
          colors = "auto";
        };

        home.shellAliases = {
          ls = "eza";
          ll = "eza -la";
          lt = "eza --tree --level=3";
        };
      };
    };
}
