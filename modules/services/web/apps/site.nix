{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.services.web.apps.site;
in
with lib; {
  options.tudor.services.web.apps.site.enable = mkEnableOption "site";

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."tudorr.ro" = {
      forceSSL = true;
      enableACME = true;
      root = "/";

      locations = {
        "/" = {
          alias = "${pkgs.tudor.site}/";
          index = "index.html";
        };

        "/blog/" = {
          alias = "${pkgs.tudor.blog}/";
          index = "index.html";
        };
      };
    };

    services.nginx.virtualHosts."www.tudorr.ro" = {
      enableACME = true;
      globalRedirect = "tudorr.ro";
    };
  };
}
