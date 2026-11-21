{ inputs, ... }: {
  flake.modules.nixos.cryptdrives =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.cryptdrives;

      driveModule = lib.types.submodule {
        options = {
          luksUUID = inputs.self.lib.mkOpt lib.types.str null;
          mapperName = inputs.self.lib.mkOpt lib.types.str null;
          mountPoint = inputs.self.lib.mkOpt lib.types.str null;
          filesystem = inputs.self.lib.mkOpt lib.types.str "ext4";
        };
      };

      mountUnitFor =
        mountPoint:
        let
          stripped = lib.strings.removePrefix "/" (lib.strings.removeSuffix "/" mountPoint);
        in
        "${builtins.replaceStrings [ "/" ] [ "-" ] stripped}.mount";

      mountUnits = map (d: mountUnitFor d.mountPoint) cfg.drives;
      candidateMounts = map (d: lib.escapeShellArg d.mountPoint) cfg.drives;
    in
    {
      options.rsnxmcst.cryptdrives = {
        enable = inputs.self.lib.enableOpt;
        poolMount = inputs.self.lib.mkOpt lib.types.str "/media";
        drives = inputs.self.lib.mkOpt (lib.types.listOf driveModule) [ ];
      };

      config = lib.mkIf cfg.enable {
        environment = {
          systemPackages = [ pkgs.mergerfs ];

          etc.crypttab.text = lib.concatMapStrings (drive: ''
            ${drive.mapperName} UUID=${drive.luksUUID} - tpm2-device=auto,nofail,discard
          '') cfg.drives;
        };

        programs.fuse = {
          enable = true;
          userAllowOther = true;
        };

        fileSystems = lib.listToAttrs (
          map (drive: {
            name = drive.mountPoint;
            value = {
              device = "/dev/mapper/${drive.mapperName}";
              fsType = drive.filesystem;
              options = [
                "defaults"
                "nofail"
                "x-systemd.device-timeout=5s"
              ];
            };
          }) cfg.drives
        );

        systemd.services.mergerfs-pool = {
          description = "Dynamic MergerFS Storage Pool";
          after = [ "local-fs.target" ] ++ mountUnits;
          requires = [ "local-fs.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;

            ExecStart = pkgs.writeShellScript "mount-mergerfs" ''
              set -eu

              active_disks=""
              for d in ${lib.concatStringsSep " " candidateMounts}; do
                if [ -d "$d" ] && ${pkgs.util-linux}/bin/mountpoint -q "$d"; then
                  if [ -z "$active_disks" ]; then
                    active_disks="$d"
                  else
                    active_disks="$active_disks:$d"
                  fi
                fi
              done

              if [ -z "$active_disks" ]; then
                echo "mergerfs-pool: no member drives currently mounted; skipping pool mount."
                exit 0
              fi

              echo "mergerfs-pool: mounting drives [$active_disks] onto ${cfg.poolMount}"

              ${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArg cfg.poolMount}
              ${pkgs.mergerfs}/bin/mergerfs \
                -o allow_other,use_ino,cache.files=partial,dropcacheonclose=true,category.create=epmfs,minfreespace=16G,moveonenospc=true,ignorepponrename=true,fsname=mergerfs-pool \
                "$active_disks" ${lib.escapeShellArg cfg.poolMount}

              ${pkgs.coreutils}/bin/chown root:wheel ${lib.escapeShellArg cfg.poolMount}
              ${pkgs.coreutils}/bin/chmod -R 2775 ${lib.escapeShellArg cfg.poolMount}
            '';

            ExecStop = pkgs.writeShellScript "unmount-mergerfs" ''
              set -eu
              if ${pkgs.util-linux}/bin/mountpoint -q ${lib.escapeShellArg cfg.poolMount}; then
                ${pkgs.util-linux}/bin/umount ${lib.escapeShellArg cfg.poolMount}
              fi
            '';
          };
        };

      };
    };
}
