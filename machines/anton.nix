# desktop
{ config, lib, pkgs, ... }:
{
  tudor.hax.enable = true;

  tudor.graphicalSession.enable = true;
  tudor.tools.emacs.enable = true;
  tudor.tools.neuron.enable = true;
  tudor.langs.langSupport.enable = true;
}
