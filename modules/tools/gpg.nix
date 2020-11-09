{ config, pkgs, ... }:
let
  graphicalSessionCfg = config.tudor.graphicalSession;
  pinentry = if graphicalSessionCfg.enable then pkgs.pinentry-gnome else pkgs.pinentry;
in
{
  tudor.home = {
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = if graphicalSessionCfg.enable then "gnome3" else "curses";
    };

    home.packages = [ pinentry ];
  };
}
