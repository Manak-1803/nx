{ self, inputs, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];

  flake = {
    nixosModules = self.modules.nixos;
    homeModules = self.modules.homeManager;
  };
}
