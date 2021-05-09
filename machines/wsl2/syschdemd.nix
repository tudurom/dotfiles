# Borrowed from github.com/Trundle/NixOS-WSL
{ lib, pkgs, config, defaultUser, ... }:

pkgs.substituteAll {
  name = "syschdemd";
  src = ./syschdemd.sh;
  dir = "bin";
  isExecutable = true;

  buildInputs = with pkgs; [ daemonize ];

  inherit (pkgs) daemonize;
  inherit defaultUser;
  inherit (config.security) wrapperDir;
  fsPackagesPath = lib.makeBinPath config.system.fsPackages;
  vars = lib.concatStringsSep " " [
    "WSL_DISTRO_NAME"
    "WSL_INTEROP"
    "WSLENV"
    "DISPLAY"
    "WAYLAND_DISPLAY"
    "PULSE_SERVER"
  ];
}
