{ config, lib, pkgs, ... }:
let
  cfg = config.systemModules.services.web.nginx;
in
with lib; {
  options.systemModules.services.web.nginx.enable = mkEnableOption "nginx";

  config = mkIf cfg.enable {
    security.acme = {
      defaults.email = "tudor@tudorr.ro";
      acceptTerms = true;
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
