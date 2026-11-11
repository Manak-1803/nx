{ inputs, ... }: {
  flake.modules.nixos.disko =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.disko;

      functions = {
        luksNames = lib.imap1 (
          idx: device: {
            name = device;
            value = "p${toString idx}";
          }
        );

        btrfsSubvolumes = builtins.mapAttrs (
          name: path: {
            mountpoint = path;
            mountOptions = [
              "noatime"
              "compress=zstd"
              "discard=async"
            ];
          }
        );

        luksOtherDisks = map (disk: {
          name = luksNames.${disk};
          value = {
            type = "disk";
            device = disk;
            content = {
              type = "gpt";
              partitions = {
                crypt = {
                  size = "100%";
                  content = {
                    type = "luks";
                    name = luksNames.${disk};
                    passwordFile = "/tmp/luksKey";

                    settings = {
                      allowDiscards = true;
                      crypttabExtraOpts = [ "tpm2-device=auto" ];
                    };
                  };
                };
              };
            };
          };
        });
      };

      luksNames = lib.pipe cfg.otherDisks [
        functions.luksNames
        lib.listToAttrs
      ];
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];

      options.rsnxmcst.disko = {
        enable = inputs.self.lib.enableOpt;
        impermanent = inputs.self.lib.enableOpt;
        swapSize = inputs.self.lib.mkOpt (with lib.types; nullOr str) null;
        mainDisk = inputs.self.lib.mkOpt (with lib.types; nullOr str) null;
        otherDisks = inputs.self.lib.mkOpt (with lib.types; listOf str) [ ];
        btrfsSubvolumes = inputs.self.lib.mkOpt (with lib.types; attrsOf str) { };
      };

      config = lib.mkIf cfg.enable {
        disko.devices = {
          disk = {
            main = {
              type = "disk";
              device = cfg.mainDisk;
              content = {
                type = "gpt";
                partitions = {
                  ESP = {
                    size = "1G";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = [ "umask=0077" ];
                    };
                  };

                  swap = {
                    size = cfg.swapSize;
                    content = {
                      type = "luks";
                      name = "cryptswap";
                      passwordFile = "/tmp/luksKey";

                      settings = {
                        allowDiscards = true;
                        crypttabExtraOpts = [ "tpm2-device=auto" ];
                      };

                      content = {
                        type = "swap";
                        discardPolicy = "both";
                        resumeDevice = true;
                      };
                    };
                  };

                  crypt = {
                    size = "100%";
                    content = {
                      type = "luks";
                      name = "p0";
                      passwordFile = "/tmp/luksKey";

                      settings = {
                        allowDiscards = true;
                        crypttabExtraOpts = [ "tpm2-device=auto" ];
                      };

                      content = {
                        type = "btrfs";
                        extraArgs = [
                          "-f"
                          "-d"
                          "single"
                          "-m"
                          "dup"
                        ]
                        ++ (lib.pipe luksNames [
                          builtins.attrValues
                          (map (name: "/dev/mapper/${name}"))
                        ]);

                        subvolumes = lib.pipe cfg.btrfsSubvolumes [ functions.btrfsSubvolumes ];
                      };
                    };
                  };
                };
              };
            };
          }
          // lib.pipe cfg.otherDisks [
            functions.luksOtherDisks
            lib.listToAttrs
          ];
        }
        // lib.optionalAttrs cfg.impermanent {
          nodev = {
            "/" = {
              fsType = "tmpfs";
              mountOptions = [
                "size=25%"
                "mode=755"
              ];
            };
          };
        };
      };
    };
}
