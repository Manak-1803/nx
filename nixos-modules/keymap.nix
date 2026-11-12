{ inputs, ... }: {
  flake.modules.nixos.keymap =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.keymap;
    in
    {
      options.rsnxmcst.keymap = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        services.xserver.xkb = {
          layout = "us";
          variant = "symbolic";
        };

        console = {
          earlySetup = true;
          keyMap = "us";
        };
      };
    };
}
