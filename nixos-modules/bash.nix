{ inputs, ... }: {
  flake.modules.nixos.bash =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.bash;
    in
    {
      options.rsnxmcst.bash = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.bash = {
          enable = true;
          completion.enable = true;
          undistractMe.enable = true;
        };
      };
    };
}
