{
  flake.modules.generic.terra = {
    rsnxmcst = {
      amd-cpu.enable = true;
      amd-gpu.enable = true;
      audio.enable = true;
      bluetooth.enable = true;
      disko.enable = true;
      networkmanager.enable = true;
      tpm.enable = true;

      disko.impermanent = true;
      disko.swapSize = "72G";
      disko.mainDisk = "/dev/disk/by-id/nvme-WD_Blue_SN580_2TB_24144A803567";
      disko.btrfsSubvolumes = {
        "@nix" = "/nix";
        "@persist" = "/persist";
      };
    };

    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usbhid"
      "uas"
      "sd_mod"
    ];

    fileSystems."/nix".neededForBoot = true;
    fileSystems."/persist".neededForBoot = true;
  };
}
