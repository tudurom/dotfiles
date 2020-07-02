{ config, pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    options.smoothScroll = true;
  };
}
