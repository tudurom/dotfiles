{ config, pkgs, ... }:
let
  pinentry = if config.tudor.graphicalSession.enable then pkgs.pinentry-gnome else pkgs.pinentry;
in
{
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "gnome3";

  tudor.hax.wrappers = [
    "${pinentry}/bin/pinentry"
  ];

  home.packages = [ pinentry ];
}
