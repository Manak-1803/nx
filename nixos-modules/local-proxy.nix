{ inputs, ... }: {
  flake.modules.nixos.local-proxy =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.local-proxy;
    in
    {
      options.rsnxmcst.local-proxy = {
        enable = inputs.self.lib.enableOpt;
        services = inputs.self.lib.mkOpt (with lib.types; attrsOf str) { };
      };

      config = lib.mkIf cfg.enable {
        networking.hosts = {
          "127.0.0.1" = lib.attrNames cfg.services;
        };

        services.caddy = {
          enable = true;
          virtualHosts = lib.mapAttrs' (hostname: target: {
            name = "http://${hostname}";
            value = {
              extraConfig = ''
                reverse_proxy http://${target}
              '';
            };
          }) cfg.services;
        };
      };
    };
}
