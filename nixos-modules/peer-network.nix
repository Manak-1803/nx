{ inputs, ... }: {
  flake.modules.nixos.peer-network =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.peer-network;
    in
    {
      options.rsnxmcst.peer-network = {
        enable = inputs.self.lib.enableOpt;
        iface = inputs.self.lib.mkOpt (with lib.types; nullOr str) null;
        peerIP = inputs.self.lib.mkOpt (with lib.types; nullOr str) null;
      };

      config = lib.mkIf cfg.enable {
        networking.networkmanager = {
          enable = true;
          ensureProfiles.profiles = {
            "${cfg.iface}-peer" = {
              connection = {
                id = "${cfg.iface}-peer";
                type = "ethernet";
                interface-name = cfg.iface;
                autoconnect = "true";
                autoconnect-priority = "50";
              };
              ipv4 = {
                method = "manual";
                addresses = cfg.peerIP;
                never-default = "true";
              };
              ipv6 = {
                method = "ignore";
                never-default = "true";
              };
            };
          };
        };
      };
    };
}
