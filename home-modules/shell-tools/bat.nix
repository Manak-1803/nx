{
  flake.modules.homeManager.shell-tools =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.shell-tools;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.bat = {
          enable = true;

          config = {
            style = "numbers,changes,header";
            italic-text = "always";
            pager = "less -FR";
          };
        };

        home.shellAliases = {
          cat = "bat -pp";
        };
      };
    };
}
