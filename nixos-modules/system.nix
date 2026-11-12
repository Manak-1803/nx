{ inputs, ... }: {
  flake.modules.nixos.system =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.system;
    in
    {
      options.rsnxmcst.system = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        sops.secrets."user-passwords/root".neededForUsers = true;
        services.xserver.excludePackages = [ pkgs.xterm ];
        boot.kernelPackages = pkgs.linuxPackages_latest;

        environment.systemPackages = with pkgs; [
          lsof
          psmisc
          usbutils
          pciutils
        ];

        users.users.root = {
          hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
        };
      };
    };
}
