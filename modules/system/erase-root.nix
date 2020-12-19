{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.system.eraseRoot;
  networkManagerCfg = config.networking.networkmanager;
  accountsDaemonCfg = config.services.accounts-daemon;
  flatpakCfg = config.services.flatpak;
  username = config.tudor.username;
in
with lib; {
  options.tudor.system = {
    eraseRoot = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
        Erase root on every reboot, using btrfs.
        '';
      };

      rootUuid = mkOption {
        type = types.str;
        description = ''
        UUID of root partition.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      nixos.source = "/persist/etc/nixos";
      "NetworkManager/system-connections".source = mkIf networkManagerCfg.enable
        "/persist/etc/NetworkManager/system-connections";
      adjtime.source = "/persist/etc/adjtime";
      NIXOS.source = "/persist/etc/NIXOS";
    };

    systemd.tmpfiles.rules = (if networkManagerCfg.enable then [
      "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
      ''F /tmp/test-file - - - - test\na\nb\n''
    ] else []) ++ (if accountsDaemonCfg.enable then [
      ''F /var/lib/AccountsService/users/${username} 0644 root root - [User]\nLanguage=\nSession=\nXSession=sway\nIcon=/home/${username}/.iface\nSystemAccount=false\n''
    ] else []) ++ (if flatpakCfg.enable then [
      "L /var/lib/flatpak - - - - /persist/var/lib/flatpak"
    ] else []);

    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    services.openssh = {
      hostKeys = [
        {
          path = "/persist/etc/ssh/host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persist/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };

    boot.initrd.postDeviceCommands =
      if cfg.rootUuid == "" then
        throw "Must supply rootUuid for root erasure"
      else
        pkgs.lib.mkBefore ''
        mkdir -p /mnt

        mount -o subvol=/ /dev/disk/by-uuid/${cfg.rootUuid} /mnt
        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        umount /mnt
      '';

    environment.systemPackages = [
      (pkgs.writeScriptBin "fsdiff" ''
      #!${pkgs.stdenv.shell}
      alias btrfs="${pkgs.btrfs-progs}/bin/btrfs"
      alias sudo="${pkgs.sudo}/bin/sudo"

      set -euo pipefail

      OLD_TRANSID=$(sudo btrfs subvolume find-new /mnt/root-blank 9999999)
      OLD_TRANSID=''${OLD_TRANSID#transid marker was }

      sudo btrfs subvolume find-new "/mnt/root" "$OLD_TRANSID" |
      sed '$d' |
      cut -f17- -d' ' |
      sort |
      uniq |
      while read path; do
        path="/$path"
        if [ -L "$path" ]; then
          : # The path is a symbolic link, so is probably handled by NixOS already
        elif [ -d "$path" ]; then
          : # The path is a directory, ignore
        else
          echo "$path"
        fi
      done
      '')
    ];
  };
}
