{ config, pkgs, ... }:
{
  home.packages = [ pkgs.mako ];
  xdg.configFile."mako/config".text = ''
  markup=1
  default-timeout=5000
  format=<b>%a\n%s</b>\n%b
  group-by=app-name,summary
  icon-path=/usr/share/icons/Adwaita

  [grouped=true]
  format=(%g) <b>%a\n%s</b>\n%b
  '';
}
