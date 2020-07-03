{ config, pkgs, ... }:
{
  services.gpg-agent.enable = true;

  home.packages = with pkgs; [
    (if config.tudor.graphicalSession.enable then pinentry-gnome else pinentry)
  ];
}
