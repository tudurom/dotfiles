{ options, config, lib, pkgs, ... }:
let
  sources = import ./nix/sources.nix;

  cfg = config.tudor;
  cfgEraseRoot = config.tudor.system.eraseRoot;
in
with lib; {
  imports = [
    "${sources.home-manager}/nixos"
    #<home-manager/nixos>

    ./modules
    ./machines/current
  ];

  options = {
    tudor.username = mkOption {
      type = types.str;
      default = "tudor";
    };
  };

  config = {
    nix = {
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
      };
      trustedUsers = [ "tudor" ];
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    i18n.defaultLocale = "ro_RO.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    time.timeZone = "Europe/Bucharest";

    nixpkgs.overlays = import ./packages;
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      binutils
      coreutils
      file
      gnumake
      gnupg
      neovim
      tree
      unzip
      wget
      zip
    ];

    documentation.man.generateCaches = true;
    documentation.dev.enable = true;

    users.mutableUsers = false;
    users.users.root.hashedPassword = "";
    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      uid = 1000;
      passwordFile = if cfgEraseRoot.enable then
        "/persist/passwds/.tudor.passwd"
      else
        "/root/passwds/.tudor.passwd"; # root partition is needed for boot then
      home = "/home/${cfg.username}";
    };

    # quick boot
    systemd.services.NetworkManager-wait-online.enable = false;

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
    home-manager.users.${cfg.username} = lib.mkAliasDefinitions options.tudor.home;

    boot.plymouth.enable = true;

    system.stateVersion = "20.03";
  };
}
