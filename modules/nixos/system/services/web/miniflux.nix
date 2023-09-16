{ config, lib, pkgs, ... }:
let
  cfg = config.systemModules.services.web.miniflux;
in
with lib; {
  options.systemModules.services.web.miniflux.enable = mkEnableOption "Enable Miniflux";

  config = mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.age.secrets.miniflux-credentials.path;     
      config.LISTEN_ADDR = "localhost:8638";
      config.BASE_URL = "https://rss.tudorr.ro/";
      config.FETCH_YOUTUBE_WATCH_TIME = "1";
    };

    #services.nginx.virtualHosts."rss.tudorr.ro" = {
    #  forceSSL = true;
    #  enableACME = true;
    #  locations."/" = {
    #    proxyPass = "http://${config.services.miniflux.config.LISTEN_ADDR}/";
    #  };
    #};
  };
}
