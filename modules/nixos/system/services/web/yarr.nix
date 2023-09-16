{ config, lib, pkgs, ... }:
let
  cfg = config.systemModules.services.web.yarr;
  yarrPkg = pkgs.yarr;
in
with lib; {
  options.systemModules.services.web.yarr.enable = mkEnableOption "Enable yarr";

  config = mkIf cfg.enable {
    services.yarr = {
      enable = true;
      environmentFile = config.age.secrets.yarr-credentials.path;
    };

    services.nginx.virtualHosts."rss.tudorr.ro" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:7070/";
      };
    };
  };
}
