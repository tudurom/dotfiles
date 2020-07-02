{ config, pkgs, ... }:
{
  systemd.user.tmpfiles.rules = [
    "D %h/tmp/downloads - - -"
    "D %h/tmp - - -"
  ];
}
