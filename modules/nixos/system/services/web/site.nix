{ config, pkgs, lib, flake, ... }:
let
  cfg = config.systemModules.services.web.site;
in
with lib; {
  options.systemModules.services.web.site = {
    enable = mkEnableOption "site";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: let
        system = final.system;
      in {
        # https://discourse.nixos.org/t/namespacing-scoping-a-group-of-packages/13782/10
        # I couldn't be bothered
        tudorSite = flake.inputs.site.packages.${system}.site;
        tudorBlog = flake.inputs.blog.packages.${system}.blog;
      })
    ];

    services.nginx.virtualHosts."tudorr.ro" = {
      forceSSL = true;
      enableACME = true;
      root = "/";
      default = true;

      locations = {
        "/" = {
          alias = "${pkgs.tudorSite}/";
          index = "index.html";
        };

        "/blog/" = {
          alias = "${pkgs.tudorBlog}/";
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
