{ inputs, ... }: {
  flake.modules.nixos.postgresql =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.postgresql;
    in
    {
      options.rsnxmcst.postgresql = {
        enable = inputs.self.lib.enableOpt;
        userDatabases = inputs.self.lib.mkOpt (with lib.types; listOf str) [ ];
      };

      config = lib.mkIf cfg.enable {
        containers.postgresql = inputs.self.lib.mkContainer {
          address = "10.18.30.62/16";

          bindMounts = {
            "/var/lib/postgresql" = {
              hostPath = "/var/lib/containers/postgresql";
              isReadOnly = false;
            };
          };

          module = {
            networking.firewall.allowedTCPPorts = [ 5432 ];

            services.postgresql = {
              enable = true;
              enableTCPIP = true;

              settings = {
                shared_preload_libraries = [ "pgx_ulid" ];
              };

              extensions =
                ps: with ps; [
                  age
                  pgmq
                  pgvector
                  pgx_ulid
                ];

              ensureDatabases = cfg.userDatabases;
              ensureUsers = map (user: {
                name = user;
                ensureDBOwnership = true;
              }) cfg.userDatabases;

              authentication = lib.mkForce ''
                # TYPE  DATABASE        USER            ADDRESS                 METHOD
                local   all             all                                     trust
                host    all             all             10.18.0.0/16        trust
              '';
            };
          };
        };
      };
    };
}
