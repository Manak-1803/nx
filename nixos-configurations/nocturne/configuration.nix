{
  flake.modules.generic.nocturne = {
    rsnxmcst = {
      bash.enable = true;
      cloudflare-warp.enable = true;
      containers.enable = true;
      fwupd.enable = true;
      gnome.enable = true;
      home-manager.enable = true;
      impermanence.enable = true;
      keymap.enable = true;
      libvirtd.enable = true;
      locale.enable = true;
      nh.enable = true;
      nix-ld.enable = true;
      nix.enable = true;
      nixpkgs.enable = true;
      podman.enable = true;
      secrets.enable = true;
      steam.enable = true;
      sudo.enable = true;
      system.enable = true;
      systemd-boot.enable = true;
      virt-manager.enable = true;

      nh.flakePath = "/home/cain/Projects/nx";

      nix.substituters = {
        "https://nix-community.cachix.org" =
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

        "https://cache.nixos-cuda.org" =
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=";

        "https://cache.rsnxmcst.dedyn.io/main" = "main:eZ8vO7Zjnm/DQLtFSGpQAAjqktA6TgHtR+EAcVl29CQ=";
      };
    };

    nixpkgs.config.cudaSupport = true;
    networking.hostName = "nocturne";
    users.mutableUsers = false;

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.11";
  };
}
