{ config, lib, pkgs, vars, ...}:
let
  cfg = config.systemModules.services.web.cgit;
  readmeFile = ./cgit-root-readme.md;
  logoFile = ./logo.png;
  repoDir = "/home/${vars.username}/git/";
  configFile = pkgs.writeText "cgitrc" ''
    css=/cgit.css
    logo=/logo.png
    favicon=/favicon.ico

    virtual-root=/
    root-title=Gitul lui Tudor
    root-desc=Scrípturi sau scriptúri?
    noplainemail=1

    mimetype.gif=image/gif
    mimetype.png=image/png
    mimetype.svg=image/svg+xml
    mimetype.jpeg=image/jpeg
    mimetype.jpg=image/jpg
    mimetype.html=text/html
    mimetype.pdf=application/pdf

    about-filter=${pkgs.cgit}/lib/cgit/filters/about-formatting.sh
    source-filter=${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py
    readme=:README.md
    readme=:README
    root-readme=${readmeFile}
    enable-index-owner=0

    snapshots=tar.gz zip

    section-from-path=1
    scan-path=${repoDir}
  '';
in
with lib; {
  options.systemModules.services.web.cgit.enable = mkEnableOption "cgit";

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
        "=/logo.png" = {
          alias = "${logoFile}";
        };

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
