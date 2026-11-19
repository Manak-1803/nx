{ inputs, ... }: {
  flake.modules.homeManager.rayburst =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.rayburst;
    in
    {
      options.rsnxmcst.rayburst = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.rayburst ];
        rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/dev.aninsomniacy.rayburst" ];
      };
    };
}
