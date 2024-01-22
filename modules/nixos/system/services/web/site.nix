{ config, pkgs, lib, flake, ... }:
let
  cfg = config.systemModules.services.web.site;
in
with lib; {
  options.systemModules.services.web.site = {
    enable = mkEnableOption "site";
    webRoot = mkOption {
      description = "Website webroot";
      type = types.str;
      default = "/srv/site";
    };
    webRootUser = mkOption {
      description = "User who places files in webroot";
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        tudor = {
          inherit (flake.inputs.site.packages.${final.system}) site;
          inherit (flake.inputs.blog.packages.${final.system}) blog;
        } // optionalAttrs (prev ? "tudor") prev.tudor;
      })
    ];

    systemd.tmpfiles.rules =
      assert cfg.webRootUser != "";
    [
      "d ${cfg.webRoot} 2755 ${cfg.webRootUser} nginx -"
    ];

    services.nginx.virtualHosts."tudorr.ro" = {
      forceSSL = true;
      enableACME = true;
      root = "/";
      default = true;

      locations = {
        "/" = {
          alias = "${cfg.webRoot}/";
          index = "index.html";
        };
      };
    };

    services.nginx.virtualHosts."www.tudorr.ro" = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "tudorr.ro";
    };
  };
}
