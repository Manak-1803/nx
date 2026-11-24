{ inputs, ... }: {
  flake.modules.homeManager.lmstudio =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.lmstudio;
    in
    {
      imports = [ inputs.lmstudio.homeModules.default ];

      options.rsnxmcst.lmstudio = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.lmstudio = {
          enable = true;
          server.enable = true;
          server.autostart = true;
        };

        rsnxmcst.impermanence.directories = [
          "${config.xdg.dataHome}/lmstudio"
          "${config.xdg.configHome}/LM Studio"
        ];
      };
    };
}
