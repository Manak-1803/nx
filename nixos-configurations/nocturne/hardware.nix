{
  flake.modules.generic.nocturne = {
    rsnxmcst = {
      amd-cpu.enable = true;
      amd-gpu.enable = true;
      audio.enable = true;
      bluetooth.enable = true;
      disko.enable = true;
      networkmanager.enable = true;
      nvidia-gpu.enable = true;
      nvidia-prime.enable = true;
      tpm.enable = true;

      disko.impermanent = true;
      disko.swapSize = "48G";
      disko.mainDisk = "/dev/disk/by-id/nvme-SKHynix_HFS001TEJ9X115N_AMCCN00671060CN6H";
      disko.btrfsSubvolumes = {
        "@nix" = "/nix";
        "@persist" = "/persist";
      };

      nvidia-prime.iGPU = "amd";
      nvidia-prime.discreteBus = "PCI:1@0:0:0";
      nvidia-prime.integratedBus = "PCI:6@0:0:0";
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
