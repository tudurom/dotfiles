{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.services.web.apps.vaultwarden;
in
with lib; {
  options.tudor.services.web.apps.vaultwarden.enable = mkEnableOption "vaultwarden";

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        domain = "https://bw.tudorr.ro";
        signupsAllowed = false;
        rocketPort = 8080;
        rocketLog = "critical";
      };
      dbBackend = "sqlite";
    };

    services.nginx.virtualHosts."bw.tudorr.ro" = {
      forceSSL = true;
      enableACME = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8080";
        };

        "/notifications/hub" = {
          proxyPass = "http://127.0.0.1:3012";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };

        "/notifications/hub/negotiate" = {
          proxyPass = "http://127.0.0.1:8080";
        };
      };

      extraConfig = ''
        client_max_body_size 128M;
      '';
    };
  };
}
