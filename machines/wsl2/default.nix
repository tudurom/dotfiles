{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  defaultUser = config.tudor.username;
in
{
  imports = [ ./wireguard.nix ];

  i18n.defaultLocale = "ro_RO.UTF-8";
  time.timeZone = "Europe/Amsterdam";

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = defaultUser;
    startMenuLaunchers = true;
    compatibility.interopPreserveArgvZero = true;
  };

  tudor.tools.emacs.enable = true;
  tudor.langs.langSupport.enable = true;

  tudor.graphicalSession.minimal.enable = true;

  # Makes multiuser.target the default user target instead of graphical.target
  # Which is good, this is WSL after all
  services.xserver.autorun = false;
  services.xserver.displayManager.startx.enable = true;

  #tudor.home.home.file.".wslgconfig".text = ''
  #  WESTON_RDP_DISABLE_HI_DPI_SCALING=true
  #'';

  # For the ltex vscode extension
  tudor.home.home.packages = with pkgs; [ adoptopenjdk-jre-hotspot-bin-11 ];
}
