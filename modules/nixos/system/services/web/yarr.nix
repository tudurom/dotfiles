{ config, lib, flake, ... }:
let
  cfg = config.systemModules.services.web.yarr;
in
with lib; {
  imports = [ flake.inputs.yarr-nix.nixosModules.default ];

  options.systemModules.services.web.yarr.enable = mkEnableOption "Enable yarr";

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      flake.inputs.yarr-nix.overlays.default
    ];
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
