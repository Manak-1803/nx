{ inputs, ... }: {
  flake.modules.nixos.networkmanager =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.networkmanager;
    in
    {
      options.rsnxmcst.networkmanager = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        networking.networkmanager = {
          enable = true;
          connectionConfig = {
            "connection.mdns" = 2;
          };
        };

        rsnxmcst = {
          user-cain.groups = [ "networkmanager" ];
          impermanence.directories = [ "/etc/NetworkManager/system-connections" ];
        };
      };
    };
}
