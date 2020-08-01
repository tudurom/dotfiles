# laptop
{ config, lib, pkgs, ... }:
{
  tudor.hax.enable = true;

  tudor.graphicalSession.enable = true;
  tudor.tools.emacs.enable = true;
  tudor.langs.langSupport.enable = true;
  home.packages = with pkgs; [libtool];
}
