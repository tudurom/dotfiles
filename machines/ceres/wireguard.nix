{ config, pkgs, lib, ... }:
{
  environment.systemPackages = [ pkgs.wireguard ];

  networking.nat = {
    enable = true;
    externalInterface = "enp0s25";
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.66.66.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/root/wg-priv-key";

    postUp = ''
      set -x
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.66.66.1/24 -o enp0s25 -j MASQUERADE

      ${pkgs.iproute}/bin/ip route del 192.168.111.0/24
      ${pkgs.iproute}/bin/ip route add 192.168.111.0/24 via 10.66.66.100 src 192.168.12.115
    '';

    preDown = ''
      set -x
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.66.66.1/24 -o enp0s25 -j MASQUERADE
    '';

    peers = [
      # s9
      {
        publicKey = "6XewpDdU4OVrYdPdk5nc4V2DJQ91ggHKcC5lHb16nWA=";
        allowedIPs = [ "10.66.66.2/32" ];
      }
      # s8
      {
        publicKey = "OeVODMIt752xhTC70H9I3y3D/TcOwPC/aYBTAIfYRCQ=";
        allowedIPs = [ "10.66.66.3/32" ];
      }
      # poarta
      {
        publicKey = "6brkdiZ0S91ySH2NoDFVmVRrL7Tx8bV8vk4hatxg7gM=";
        allowedIPs = [ "10.66.66.100/32" "192.168.111.0/24" ];
      }
    ];
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  services.dnsmasq = {
    enable = true;
    extraConfig = ''
      interface=wg0
    '';
  };
}
