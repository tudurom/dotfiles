{ config, pkgs, lib, ... }:
{
  environment.systemPackages = [ pkgs.wireguard ];

  networking.firewall.allowedUDPPorts = [ 51820 ];
  #networking.firewall.trustedInterfaces = [ "wg0" ];

  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.66.66.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/root/wg-priv-key";

    peers = [
      # poarta
      {
        publicKey = "6brkdiZ0S91ySH2NoDFVmVRrL7Tx8bV8vk4hatxg7gM=";
        allowedIPs = [ "10.66.66.100/32" ];
      }
    ];
  };
}
