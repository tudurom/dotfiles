{ config, lib, pkgs, ... }:
let
  cfg = config.systemModules.services.web.linkding;
  version = "1.21.0";
in
with lib; {
  options.systemModules.services.web.linkding.enable = mkEnableOption "Enable linkding";

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.linkding = {
      image = "docker.io/sissbruecker/linkding:${version}";
      ports = [ "127.0.0.1:8316:9090" ];
      volumes = [ "linkding_data:/etc/linkding/data" ];
      environmentFiles = [ config.age.secrets.linkding-credentials.path ];
      environment = {
       LD_CSRF_TRUSTED_ORIGINS = "https://links.tudorr.ro";       
      };
    };

    services.nginx.virtualHosts."links.tudorr.ro" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8316/";
      };
    };
  };
}
