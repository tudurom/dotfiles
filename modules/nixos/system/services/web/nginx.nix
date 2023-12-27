{ config, lib, ... }:
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

    # for checking various things: I recommend https://internet.nl/
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;

      appendHttpConfig = let
        # one year
        maxAge = 31536000;
      in ''
        map $scheme $hsts_header {
          https "max-age=${builtins.toString maxAge}";
        }
        add_header Strict-Transport-Security $hsts_header;

        add_header Referrer-Policy "same-origin";
        add_header X-Content-Type-Options nosniff;
      '';
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
