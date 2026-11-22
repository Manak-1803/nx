{ inputs, ... }: {
  flake.modules.homeManager.fragments =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.fragments;
    in
    {
      options.rsnxmcst.fragments = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.fragments ];
        rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/fragments" ];
      };
    };
}
