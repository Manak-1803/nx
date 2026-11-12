{ inputs, ... }: {
  flake.modules.nixos.atuin-server =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.atuin-server;
    in
    {
      options.rsnxmcst.atuin-server = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        containers.atuin-server = inputs.self.lib.mkContainer {
          address = "10.18.238.151/16";

          module = {
            services.atuin = {
              enable = true;
              openFirewall = true;

              host = "10.18.238.151";
              port = 8888;

              database.uri = "postgresql://atuin@10.18.30.62:5432/atuin";
            };
          };
        };

        rsnxmcst.postgresql.userDatabases = [ "atuin" ];
      };
    };
}
