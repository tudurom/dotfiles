{ config, pkgs, lib, ... }:
{
  xdg.enable = true;

  xdg.userDirs = {
    enable = true;

    desktop = "\$HOME/usr/desktop";
    download = "\$HOME/tmp/downloads";
    documents = "\$HOME/usr/docs";
    music = "\$HOME/usr/music";
    pictures = "\$HOME/usr/images";
    publicShare = "/dev/null";
    templates = "/dev/null";
    videos = "\$HOME/usr/videos";
  };
}
