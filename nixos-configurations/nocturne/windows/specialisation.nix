{
  flake.modules.generic.nocturne = { lib, ... }: {
    specialisation.windows.configuration = {
      environment.etc."specialisation".text = "windows";

      rsnxmcst = {
        jellyfin.enableNvidia = lib.mkForce false;
      };
    };
  };
}
