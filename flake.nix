{
  description = "My config";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-21.11;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    home-manager = {
      url = github:nix-community/home-manager/release-21.11;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = github:nix-community/emacs-overlay;
    nixos-hardware.url = github:nixos/nixos-hardware;

    nix-ld.url = github:Mic92/nix-ld;
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  nixConfig = {
    substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  outputs = inputs@{ self, utils, nixpkgs, nixpkgs-unstable, home-manager,
                     emacs-overlay, nixos-hardware, nix-ld, ... }:
    let
      commonModules = [
      ];
    in utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channels.unstable.input = nixpkgs-unstable;
      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = channels: [
          (final: prev: {
            tudor = {
            };
          })
        ];
      };
      channelsConfig = { allowUnfree = true; };

      hostDefaults.modules = [
        ./configuration.nix home-manager.nixosModules.home-manager nixpkgs.nixosModules.notDetected
      ];

      hosts = {
        wsl2.modules = commonModules ++ [
          ./machines/wsl2

          nix-ld.nixosModules.nix-ld

          ({ pkgs, ... }: {
            environment.systemPackages = [ pkgs.fup-repl ];
          })
        ];
      };
    };
}
