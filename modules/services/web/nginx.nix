{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.services.web.nginx;
in
with lib; {
  options.tudor.services.web.nginx.enable = mkEnableOption "nginx";

  config = mkIf cfg.enable {
    security.acme = {
      email = "tudor@tudorr.ro";
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
