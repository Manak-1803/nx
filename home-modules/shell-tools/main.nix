{ inputs, ... }: {
  flake.modules.homeManager.shell-tools =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.shell-tools;
    in
    {
      options.rsnxmcst.shell-tools = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs = {
          fd.enable = true;
          ripgrep.enable = true;
        };
      };
    };
}
