{
  config,
  lib,
  pkgs,
  utils,
  flake,
  ...
}:
with lib; let
  cfg = config.systemModules.services.web.gitea;
in {
  options.systemModules.services.web.gitea = {
    enable = mkEnableOption "Enable Gitea";
    actions = {
      enable = mkEnableOption "Enable Gitea Actions runner";
      host = mkOption {
        type = types.str;
        description = "Gitea actions runner LAN IP";
        default = "";
      };
      cachePort = mkOption {
        type = types.int;
        description = "Gitea actions runner cache port";
        default = 8088;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
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
        settings."repository.pull-request" = {
          DEFAULT_MERGE_STYLE = "rebase";
        };
      };

      services.nginx.virtualHosts."git.tudorr.ro" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:3001/";
        };
      };
    }
    (mkIf cfg.actions.enable (import ./gitea-actions.nix {
      inherit config lib pkgs utils flake;
    }))
  ]);
}
