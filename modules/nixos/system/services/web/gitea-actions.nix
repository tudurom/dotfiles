# HUGE thanks to this: https://git.clan.lol/clan/clan-infra/src/branch/main/modules/web01/gitea/actions-runner.nix
# Largely copied from there.
# This file is meant to be conditionally included in ./gitea.nix
{
  config,
  lib,
  pkgs,
  utils,
  flake,
  ...
}:
with lib; let
  cfg = config.systemModules.services.web.gitea.actions;
  name = "${config.networking.hostName}-1";
  escapedName = utils.escapeSystemdPath name;
  storeDeps = pkgs.runCommand "store-deps" {} ''
    mkdir -p $out/bin
    for dir in ${toString (with pkgs; [coreutils findutils gnugrep gawk git nix bash jq nodejs])}; do
      for bin in "$dir"/bin/*; do
        ln -s "$bin" "$out/bin/$(basename "$bin")"
      done
    done

    # Add SSL CA certs
    mkdir -p $out/etc/ssl/certs
    cp -a "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" $out/etc/ssl/certs/ca-bundle.crt
  '';
in {
  services.gitea = {
    settings.actions.ENABLED = true;
  };

  systemd.services.gitea-runner-nix-image = {
    wantedBy = ["multi-user.target"];
    after = ["podman.service"];
    requires = ["podman.service"];
    path = with pkgs; [
      config.virtualisation.podman.package
      gnutar
      shadow
      getent
    ];

    # we also include etc here because the cleanup job also wants the nixuser to be present
    script = ''
      set -eux -o pipefail
      mkdir -p etc/nix

      # Create an unpriveleged user that we can use also without the run-as-user.sh script
      touch etc/passwd etc/group
      groupid=$(cut -d: -f3 < <(getent group nixuser))
      userid=$(cut -d: -f3 < <(getent passwd nixuser))
      groupadd --prefix $(pwd) --gid "$groupid" nixuser
      emptypassword='$6$1ero.LwbisiU.h3D$GGmnmECbPotJoPQ5eoSTD6tTjKnSWZcjHoVTkxFLZP17W9hRi/XkmCiAMOfWruUwy8gMjINrBMNODc7cYEo4K.'
      useradd --prefix $(pwd) -p "$emptypassword" -m -d /tmp -u "$userid" -g "$groupid" -G nixuser nixuser

      cat <<NIX_CONFIG > etc/nix/nix.conf
      accept-flake-config = true
      experimental-features = nix-command flakes
      NIX_CONFIG

      cat <<NSSWITCH > etc/nsswitch.conf
      passwd:    files mymachines systemd
      group:     files mymachines systemd
      shadow:    files

      hosts:     files mymachines dns myhostname
      networks:  files

      ethers:    files
      services:  files
      protocols: files
      rpc:       files
      NSSWITCH

      # list the content as it will be imported into the container
      tar -cv . | tar -tvf -
      tar -cv . | podman import - gitea-runner-nix
    '';
    serviceConfig = {
      RuntimeDirectory = "gitea-runner-nix-image";
      WorkingDirectory = "/run/gitea-runner-nix-image";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  users.users.nixuser = {
    group = "nixuser";
    home = "/var/empty";
    isSystemUser = true;
  };
  users.groups.nixuser = {};

  systemd.services."gitea-runner-${escapedName}-token" = {
    wantedBy = ["multi-user.target"];
    after = ["gitea.service"];
    environment = {
      GITEA_CUSTOM = "/var/lib/gitea/custom";
      GITEA_WORK_DIR = "/var/lib/gitea";
    };

    script = ''
      set -euo pipefail
      token=$(${lib.getExe config.services.gitea.package} actions generate-runner-token)
      echo "TOKEN=$token" > /var/lib/gitea-registration/${name}-token
    '';
    unitConfig.ConditionPathExists = ["!/var/lib/gitea-registration/${name}"];
    serviceConfig = flake.self.lib.harden {
      DynamicUser = false;

      User = "gitea";
      Group = "gitea";
      StateDirectory = "gitea-registration";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  virtualisation.podman = {
    enable = true;
    extraPackages = [pkgs.zfs];
  };

  virtualisation.containers.storage.settings = {
    storage.driver = "zfs";
    storage.graphroot = "/var/lib/containers/storage";
    storage.runroot = "/run/containers/storage";
    storage.options.zfs.fsname = "rpool/root/podman";
  };

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
      "gitea-runner-${escapedName}-token.service"
      "gitea-runner-nix-image.service"
    ];
    requires = [
      "gitea-runner-${escapedName}-token.service"
      "gitea-runner-nix-image.service"
    ];
  };

  services.gitea-actions-runner = {
    instances.${name} = {
      inherit name;
      enable = true;
      url = config.services.gitea.settings.server.ROOT_URL;
      tokenFile = "/var/lib/gitea-registration/${name}-token";
      labels = [
        "nix:docker://gitea-runner-nix"
        "ubuntu-latest:docker://node:lts-bookworm"
        "ubuntu-22.04:docker://node:lts-bullseye"
        "ubuntu-20.04:docker://node:lts-bullseye"
        "ubuntu-18.04:docker://node:lts-buster"
      ];
      settings = {
        container.options = "-e NIX_BUILD_SHELL=/bin/bash -e PAGER=cat -e PATH=/bin -e SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt --device /dev/kvm -v /nix:/nix -v ${storeDeps}/bin:/bin -v ${storeDeps}/etc/ssl:/etc/ssl --user nixuser --device=/dev/kvm";
        log.level = "warn";
        container.network = "host";
        container.privileged = true;
        container.valid_volumes = [
          "/nix"
          "${storeDeps}/bin"
          "${storeDeps}/etc/ssl"
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
