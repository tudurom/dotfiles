# HUGE thanks to this: https://git.clan.lol/clan/clan-infra/src/branch/main/modules/web01/gitea/actions-runner.nix
# Largely copied from there. Improved and clean afterwards.
# This file is meant to be conditionally included in ./forgejo.nix
{
  config,
  lib,
  pkgs,
  utils,
  flake,
  ...
}: let
  cfg = config.systemModules.services.web.forgejo.actions;
  name = "${config.networking.hostName}-1";
  escapedName = utils.escapeSystemdPath name;

  # inspired by
  # https://gist.github.com/fasterthanlime/e9582c4842ef00c581a042bb6057b707
  nixImage = let
    nixConfig = pkgs.writeTextFile {
      name = "nix-config";
      text = ''
        build-users-group =
        experimental-features = nix-command flakes
        max-jobs = auto
        extra-substituters = https://cache.garnix.io
        extra-trusted-public-keys = cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=
      '';
      destination = "/etc/nix/nix.conf";
    };
  in
    pkgs.dockerTools.streamLayeredImage {
      name = "forgejo-runner-nix";
      tag = "latest";
      contents = [
        nixConfig

        # for caching
        pkgs.gnutar
        pkgs.zstd

        pkgs.cacert
        pkgs.bash
        pkgs.nodejs
        pkgs.gitMinimal
        pkgs.coreutils
        pkgs.busybox
        pkgs.nix

        pkgs.dockerTools.fakeNss
        pkgs.dockerTools.caCertificates
      ];
      config.Cmd = ["/bin/bash"];
    };
in {
  services.forgejo = {
    settings.actions.ENABLED = true;
  };

  systemd.services.forgejo-runner-nix-image = {
    wantedBy = ["multi-user.target"];
    after = ["podman.service"];
    requires = ["podman.service"];
    path = [
      config.virtualisation.podman.package
    ];

    script = ''
      ${nixImage} | podman load -q
    '';

    serviceConfig = {
      RuntimeDirectory = "forgejo-runner-nix-image";
      WorkingDirectory = "/run/forgejo-runner-nix-image";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services."forgejo-runner-${escapedName}-token" = {
    wantedBy = ["multi-user.target"];
    after = ["forgejo.service"];
    environment = {
      FORGEJO_CUSTOM = "/var/lib/forgejo/custom";
      FORGEJO_WORK_DIR = "/var/lib/forgejo";
    };

    script = ''
      set -euo pipefail
      token=$(${lib.getExe config.services.forgejo.package} actions generate-runner-token)
      echo "TOKEN=$token" > /var/lib/forgejo-registration/${name}-token
    '';

    unitConfig.ConditionPathExists = ["!/var/lib/forgejo-registration/${name}"];
    serviceConfig = flake.self.lib.harden {
      DynamicUser = false;

      User = config.services.forgejo.user;
      Group = config.services.forgejo.group;
      StateDirectory = "forgejo-registration";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  virtualisation.podman = {
    enable = true;
  };

  # TODO: change to forgejo-runner once there's a NixOS
  # module for it
  systemd.services."gitea-runner-${escapedName}" = {
    serviceConfig = flake.self.lib.harden {
      # make it not dump literally everything in the syslog
      StandardOutput = "null";

      # undo some hardening

      # Node is a JIT
      MemoryDenyWriteExecute = false;
      # nix emits warnings otherwise
      ProcSubset = "all";
      # uncomment if disabling ASLR in jobs
      # LockPersonality = false;
    };
    after = [
      "forgejo-runner-${escapedName}-token.service"
      "forgejo-runner-nix-image.service"
    ];
    requires = [
      "forgejo-runner-${escapedName}-token.service"
      "forgejo-runner-nix-image.service"
    ];
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-actions-runner;
    instances.${name} = {
      inherit name;
      enable = true;
      url = config.services.forgejo.settings.server.ROOT_URL;
      tokenFile = "/var/lib/forgejo-registration/${name}-token";
      labels = [
        "nix:docker://forgejo-runner-nix"
        "ubuntu-latest:docker://node:lts-bookworm"
        "ubuntu-22.04:docker://node:lts-bullseye"
        "ubuntu-20.04:docker://node:lts-bullseye"
        "ubuntu-18.04:docker://node:lts-buster"
      ];
      settings = {
        container.options = "--device /dev/kvm -v /nix:/nix";
        log.level = "warn";
        container.network = "host";
        container.privileged = true;
        container.valid_volumes = [
          "/nix"
        ];
        cache = assert cfg.host != ""; {
          enabled = true;
          inherit (cfg) host;
          port = cfg.cachePort;
        };
      };
    };
  };
}
