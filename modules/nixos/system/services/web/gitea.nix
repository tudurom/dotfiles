{
  config,
  lib,
  utils,
  ...
}: let
  cfg = config.systemModules.services.web.gitea;
in
  with lib; let
    name = "${config.networking.hostName}-1";
  in {
    options.systemModules.services.web.gitea = {
      enable = mkEnableOption "Enable Gitea";
      enableActions = mkEnableOption "Enable Gitea Actions runner";
    };

    config = mkMerge [
      (mkIf cfg.enable {
        services.gitea = {
          enable = true;
          appName = "Tudor's Code Pantry";
          database.type = "sqlite3";
          settings.server = {
            DOMAIN = "git.tudorr.ro";
            ROOT_URL = "https://git.tudorr.ro/";
            HTTP_PORT = 3001;
          };
          settings.service = {
            DISABLE_REGISTRATION = true;
          };
        };

        services.nginx.virtualHosts."git.tudorr.ro" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:3001/";
          };
        };
      })
      (mkIf cfg.enableActions {
        services.gitea = {
          settings.actions.ENABLED = true;
        };

        virtualisation.podman.enable = true;

        systemd.services."gitea-runner-${utils.escapeSystemdPath name}" = {
          # make it not dump literally everything in the syslog
          serviceConfig.StandardOutput = "null";
        };

        services.gitea-actions-runner = {
          instances.${name} = {
            inherit name;
            enable = true;
            url = config.services.gitea.settings.server.ROOT_URL;
            tokenFile = config.age.secrets.gitea-actions-token.path;
            labels = [
              "ubuntu-latest:docker://node:lts-bookworm"
              "ubuntu-22.04:docker://node:lts-bullseye"
              "ubuntu-20.04:docker://node:lts-bullseye"
              "ubuntu-18.04:docker://node:lts-buster"
            ];
            settings = {
              log.level = "warn";
              container.network = "host";
              container.privileged = true;
            };
          };
        };
      })
    ];
  }
