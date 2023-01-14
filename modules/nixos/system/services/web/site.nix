{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.systemModules.services.web.site;
in
with lib; {
  options.systemModules.services.web.site = {
    enable = mkEnableOption "site";
  };

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
