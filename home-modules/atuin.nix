{ inputs, ... }: {
  flake.modules.homeManager.atuin =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.atuin;
    in
    {
      options.rsnxmcst.atuin = {
        enable = inputs.self.lib.enableOpt;
        serverAddress = inputs.self.lib.mkOpt (with lib.types; nullOr str) null;
      };

      config = lib.mkIf cfg.enable {
        programs.atuin = {
          enable = true;
          daemon.enable = true;
          flags = [ "--disable-up-arrow" ];
          settings = {
            style = "full";
            auto_sync = true;
            update_check = false;
            sync_frequency = "5m";
            filter_mode = "global";
            search_mode = "daemon-fuzzy";
            sync_address = cfg.serverAddress;
          };
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.dataHome}/atuin" ];
      };
    };
}
