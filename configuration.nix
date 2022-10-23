{ options, config, lib, pkgs, ... }:
let
  cfg = config.tudor;
  cfgEraseRoot = config.tudor.system.eraseRoot;
in
with lib; {
  imports = [
    ./modules
    ./cachix.nix
  ];

  options = {
    tudor.username = mkOption {
      type = types.str;
      default = "tudor";
    };
  };

  config = {
    nix = {
      package = pkgs.nixUnstable;
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
      };
      trustedUsers = [ "tudor" ];
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    #nixpkgs.overlays = import ./packages;
    #nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      bind
      binutils
      coreutils
      fd
      file
      gnumake
      gnupg
      inetutils
      neovim
      ripgrep
      sd
      tmux
      tree
      unzip
      wget
      zip

      man-pages
    ];

    documentation.man.generateCaches = true;
    documentation.dev.enable = true;

    users.mutableUsers = false;
    users.users.root.hashedPassword = "";
    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "scanner" "lp" ];
      uid = 1000;
      passwordFile = if cfgEraseRoot.enable then
        "/persist/passwds/.${cfg.username}.passwd"
      else
        "/root/passwds/.${cfg.username}.passwd"; # root partition is needed for boot then
      home = "/home/${cfg.username}";
      shell = pkgs.fish;
    };

    # quick boot
    systemd.services.NetworkManager-wait-online.enable = false;

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
    home-manager.users.${cfg.username} = lib.mkAliasDefinitions options.tudor.home;

    system.stateVersion = "20.03";
  };
}
