{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../_all
    ./hardware.nix
  ];

  nix.settings.trusted-users = ["tudor"];

  systemModules.basePackages.enable = true;
  systemModules.services = {
    dyndns.enable = true;
    ssh.enable = true;
    ssh.enableMosh = true;
    web = {
      nginx.enable = true;
      cgit.enable = false;
      forgejo = {
        enable = true;
        actions = {
          enable = true;
          host = "100.81.169.93";
          cachePort = 8088;
        };
      };
      site = {
        enable = false;
        webRootUser = "tudor";
      };
      yarr.enable = true;
    };
    ipforward.enable = true;
    tailscale.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Bucharest";

  boot.supportedFilesystems = ["zfs"];

  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-id/ata-Hitachi_HTS725025A9A364_100625PCK200VJHNKPPJ";
  };

  networking = {
    useDHCP = true;
    hostName = "ceres";
    hostId = "23247628"; # for zfs

    firewall.enable = true;

    extraHosts = ''
      192.168.12.115 ceres.localdomain
      192.168.12.200 truenas.localdomain
    '';
  };

  age.secrets = {
    tudor-password.file = ../../secrets/ceres/tudor-password.age;
    yarr-credentials.file = ../../secrets/ceres/yarr-credentials.age;
    dedyn.file = ../../secrets/ceres/dedyn.age;
  };

  users.users.tudor = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    uid = 1000;
    home = "/home/tudor";
    hashedPasswordFile = config.age.secrets.tudor-password.path;
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../id_ed25519.pub)
    ];
  };

  virtualisation = {
    podman = {
      enable = true;
      extraPackages = [pkgs.zfs];
    };
  };

  virtualisation.containers.storage.settings = {
    storage.driver = "zfs";
    storage.graphroot = "/var/lib/containers/storage";
    storage.runroot = "/run/containers/storage";
    storage.options.zfs.fsname = "rpool/root/podman";
  };

  security.sudo.wheelNeedsPassword = false;

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;
  home-manager.users.tudor = ../../users/tudor;
}
