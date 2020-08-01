{ config, pkgs, lib, ... }:
let
  homeDir = config.home.homeDirectory;
in {
  xdg.enable = true;

  home.packages = with pkgs; [
    xdg_utils
  ];

  xdg.configFile."user-dirs.conf".text = "enabled=False";

  home.activation.xdgDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    alias xdg-user-dirs-update=${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

    rm ~/.config/user-dirs.*

    xdg-user-dirs-update --set DESKTOP "${homeDir}/usr/desktop"
    xdg-user-dirs-update --set DOWNLOAD "${homeDir}/tmp/downloads";
    xdg-user-dirs-update --set DOCUMENTS "${homeDir}/usr/docs";
    xdg-user-dirs-update --set MUSIC "${homeDir}/usr/music";
    xdg-user-dirs-update --set PICTURES "${homeDir}/usr/images";
    xdg-user-dirs-update --set PUBLICSHARE "${homeDir}/.cache/junk/public";
    xdg-user-dirs-update --set TEMPLATES "${homeDir}/.cache/junk/templates";
    xdg-user-dirs-update --set VIDEOS "${homeDir}/usr/videos";
  '';
}
