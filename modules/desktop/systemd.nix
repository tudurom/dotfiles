{ config, pkgs, ... }:
{
  tudor.home = {
    systemd.user.tmpfiles.rules = [
      "D %h/tmp/downloads - - -"
      "D %h/tmp - - -"
    ];
  };
}
