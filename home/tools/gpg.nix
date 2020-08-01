{ config, pkgs, ... }:
let
  graphicalSessionCfg = config.tudor.graphicalSession;
  pinentry = if graphicalSessionCfg.enable then pkgs.pinentry-gnome else pkgs.pinentry;
in
{
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = if graphicalSessionCfg.enable then "gnome3" else "curses";
  };

  tudor.hax.wrappers = [ "${pinentry}/bin/pinentry" ];

  home.packages = [ pinentry ];
}
