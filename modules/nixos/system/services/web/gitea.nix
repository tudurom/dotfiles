{ config, lib, pkgs, ... }:
let
  cfg = config.systemModules.services.web.gitea;
in
with lib; {
  options.systemModules.services.web.gitea.enable = mkEnableOption "Enable Gitea";

  config = mkIf cfg.enable {
    services.gitea = {
      enable = true;
      appName = "Tudor's Code Pantry";
      database.type = "sqlite3";
      settings.server = {
        DOMAIN = "git.tudorr.ro";
        ROOT_URL = "https://git.tudorr.ro/";
        HTTP_PORT = 3001;
      };
    };

    services.nginx.virtualHosts."git.tudorr.ro" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:3001/";
      };
    };
  };
}
