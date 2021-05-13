{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  defaultUser = config.tudor.username;
  syschdemd = import ./syschdemd.nix { inherit lib pkgs config defaultUser; };

  envVarsGenerator = pkgs.writeScript "80-env-vars.sh" ''
    #!${pkgs.stdenv.shell}
    test -e /run/nixoswsl.env && ${pkgs.coreutils}/bin/cat /run/nixoswsl.env
  '';

  mapUserRuntimeDir = pkgs.writeScript "map-user-runtime-dir.sh" ''
    #!${pkgs.stdenv.shell}
    if [ ! -d /mnt/wslg/runtime-dir ]; then
      # WSLg is not present, so do nothing over-and-above previous
      exit
    fi

    WUID=$(${pkgs.coreutils}/bin/stat -c "%u" /mnt/wslg/runtime-dir)

    if [ $1 -eq $WUID ]; then
      # We are the WSLg user, so map the runtime-dir
      /run/wrappers/bin/mount --bind /mnt/wslg/runtime-dir /run/user/$1
      exit
    fi
  '';

  unmapUserRuntimeDir = pkgs.writeScript "unmap-user-runtime-dir.sh" ''
    #!${pkgs.stdenv.shell}
    if [ ! -d /mnt/wslg/runtime-dir ]
    then
      # WSLg is not present, so do nothing over-and-above previous
      exit
    fi

    WUID=$(${pkgs.coreutils}/bin/stat -c "%u" /mnt/wslg/runtime-dir)

    if [ $1 -eq $WUID ]
    then
      # We are the WSLg user, so unmap the runtime-dir
      /run/wrappers/bin/umount /run/user/$1
      exit
    fi
  '';
in
{
  i18n.defaultLocale = "ro_RO.UTF-8";
  time.timeZone = "Europe/Bucharest";

  # WSL is closer to a container than anything else
  boot.isContainer = true;

  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;
  environment.etc."systemd/system-environment-generators/80-env-vars.sh".source = envVarsGenerator;
  environment.etc."systemd/user-environment-generators/80-env-vars.sh".source = envVarsGenerator;

  systemd.services."user-runtime-dir@".serviceConfig = {
    ExecStartPost = "${mapUserRuntimeDir} %i";
    ExecStop = "${unmapUserRuntimeDir} %i";
  };

  networking.dhcpcd.enable = false;

  users.users.root = {
    shell = "${syschdemd}/bin/syschdemd";
    # Otherwise WSL fails to login as root with "initgroups failed 5"
    extraGroups = [ "root" ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Disable systemd units that don't make sense on WSL
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;

  systemd.services.firewall.enable = false;
  systemd.services.systemd-resolved.enable = false;
  systemd.services.systemd-udevd.enable = false;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;

  tudor.tools.emacs.enable = true;
  tudor.langs.langSupport.enable = true;

  tudor.graphicalSession.minimal.enable = true;

  # Makes multiuser.target the default user target instead of graphical.target
  # Which is good, this is WSL after all
  services.xserver.autorun = false;
  services.xserver.displayManager.startx.enable = true;

  tudor.home.home.file.".wslgconfig".text = ''
    WESTON_RDP_DISABLE_HI_DPI_SCALING=true
  '';
}
