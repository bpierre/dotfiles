# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../base.nix

      # hardware scan
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "iwlwifi" "cfg80211" ];

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  #hardware.nvidia.optimus_prime.enable = true;
  #hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:01:00.0";
  #hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";

  hardware.bluetooth.enable = true;

  networking.hostName = "p52";

  networking.networkmanager.enable = true;

  # Enables wireless support via wpa_supplicant.
  networking.wireless.enable = pkgs.lib.mkForce false;
}
