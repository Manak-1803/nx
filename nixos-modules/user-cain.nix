{ inputs, ... }: {
  flake.modules.nixos.user-cain =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.user-cain;
    in
    {
      options.rsnxmcst.user-cain = {
        enable = inputs.self.lib.enableOpt;
        groups = inputs.self.lib.mkOpt (with lib.types; listOf str) [ ];
      };

      config = lib.mkIf cfg.enable {
        sops.secrets."user-passwords/cain".neededForUsers = true;

        users.users.cain = {
          isNormalUser = true;
          description = "Arindam Shrivastava";

          group = "users";
          extraGroups = [ "wheel" ] ++ cfg.groups;

          home = "/home/cain";
          useDefaultShell = true;

          hashedPasswordFile = config.sops.secrets."user-passwords/cain".path;
        };

        home-manager.users.cain = {
          programs.home-manager.enable = true;

          home = {
            username = "cain";
            homeDirectory = "/home/cain";
            preferXdgDirectories = true;

            stateVersion = "26.11";
          };
        };
      };
    };
}
