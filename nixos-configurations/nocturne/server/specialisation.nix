{
  flake.modules.generic.nocturne =
    { lib, ... }:
    let
      disabled = {
        enable = lib.mkForce false;
      };
    in
    {
      specialisation.server.configuration = {
        rsnxmcst = {
          nut.enable = true;
          peanut.enable = true;
          nut.server.enable = true;

          cloudflare-warp = disabled;
          gnome = disabled;
          steam = disabled;
          virt-manager = disabled;

          audio = disabled;
          bluetooth = disabled;
        };

        home-manager.users.cain = {
          rsnxmcst = {
            discord = disabled;
            fonts = disabled;
            prismlauncher = disabled;
            rayburst = disabled;
            spotify = disabled;
            vscodium = disabled;
            zen-browser = disabled;
          };
        };

        services.xserver = disabled;
        environment.etc."specialisation".text = "server";
      };
    };
}
