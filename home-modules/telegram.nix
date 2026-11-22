{ inputs, ... }: {
  flake.modules.homeManager.telegram =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.telegram;
    in
    {
      options.rsnxmcst.telegram = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.telegram-desktop ];
        rsnxmcst.impermanence.directories = [ "${config.xdg.dataHome}/TelegramDesktop" ];
      };
    };
}
