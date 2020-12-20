{ config, lib, pkgs, ...}:
let
  cfg = config.tudor.services.web.apps.cgit;
  configFile = pkgs.writeText "cgitrc" ''
    css=/cgit.css
    logo=/cgit.png
    favicon=/favicon.ico

    virtual-root=/
    root-title=Gitul lui Tudor
    root-desc=Aici se află niște repouri
    noplainemail=1

    mimetype.gif=image/gif
    mimetype.png=image/png
    mimetype.svg=image/svg+xml
    mimetype.jpeg=image/jpeg
    mimetype.jpg=image/jpg
    mimetype.html=text/html
    mimetype.pdf=application/pdf

    about-filter=${pkgs.cgit}/lib/cgit/filters/html-converters/md2html
    source-filter=${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py
    root-readme=README.md

    scan-path=/home/${config.tudor.username}/git/
  '';
in
with lib; {
  options.tudor.services.web.apps.cgit.enable = mkEnableOption "cgit";

  config = mkIf cfg.enable {
    services.fcgiwrap.enable = true;

    services.nginx.virtualHosts."git.tudorr.ro" = {
      forceSSL = true;
      enableACME = true;

      root = "${pkgs.cgit}/cgit";

      extraConfig = ''
        try_files $uri @cgit;
      '';

      locations = {
        "@cgit" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root/cgit.cgi;
            fastcgi_param PATH_INFO $uri;
            fastcgi_param QUERY_STRING $args;
            fastcgi_param HTTP_HOST $server_name;
            fastcgi_param CGIT_CONFIG "${configFile}";
            fastcgi_pass unix:${config.services.fcgiwrap.socketAddress};
          '';
        };
      };
    };
  };
}
