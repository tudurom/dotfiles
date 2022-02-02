{ config, pkgs, lib, ... }:
{
  environment.systemPackages = [ pkgs.wireguard ];

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.trustedInterfaces = [ "wg0" ];

  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.66.66.69/24" ];
    privateKeyFile = "/root/wg-priv-key";

    peers = [
      # ceres
      {
        publicKey = "4+OHOccCNPmcqS2/iM/xcwsgx4r0MrBJmhi3DKOSYWc=";
        allowedIPs = [ "10.66.66.1/32" ];
        endpoint = "tudorr.ro:51820";
      }
    ];
  };
}
