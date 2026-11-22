{
  flake.modules.generic.nocturne = {
    rsnxmcst = {
      attic-server.enable = true;
      atuin-server.enable = true;
      cryptdrives.enable = true;
      dbgate.enable = true;
      jellyfin.enable = true;
      newt.enable = true;
      postgresql.enable = true;
      sshd.enable = true;

      cryptdrives = {
        poolMount = "/media";
        drives = [
          {
            luksUUID = "8aadffea-e2e6-42fc-bf98-f63f02a0104c";
            mapperName = "d0";
            mountPoint = "/mnt/disks/d0";
          }
        ];
      };

      jellyfin.enableNvidia = true;

      minecraft-server = {
        mechanicum = false;
      };
    };
  };
}
