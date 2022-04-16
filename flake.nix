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

    # So i don't have to recompile it every time i update flakes
    emacs-overlay.url = github:nix-community/emacs-overlay/5a501bb198eb96a327cdd3275608305d767e489d;
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = github:nixos/nixos-hardware;
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld.url = github:Mic92/nix-ld;
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    bw-git-helper.url = github:tudurom/bw-git-helper;
    bw-git-helper.inputs.nixpkgs.follows = "nixpkgs";
    bw-git-helper.inputs.utils.follows = "utils";

    site.url = github:tudurom/site;
    site.inputs.nixpkgs.follows = "nixpkgs";
    site.inputs.utils.follows = "utils";

    blog.url = github:tudurom/blog;
    blog.inputs.nixpkgs.follows = "nixpkgs";
    blog.inputs.utils.follows = "utils";

    co.url = "git+ssh://git@github.com/tudurom/co-work.git";
    co.inputs.utils.follows = "utils";
  };

  nixConfig = {
    substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  outputs = inputs@{ self, utils, nixpkgs, nixpkgs-unstable, home-manager,
                     nix-ld, bw-git-helper, site, blog, co, ... }:
    utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channels.unstable.input = nixpkgs-unstable;
      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = channels: [
          (final: prev: {
            tudor = {
              bw-git-helper = bw-git-helper.defaultPackage.${prev.system};
              site = site.defaultPackage.${prev.system};
              blog = blog.defaultPackage.${prev.system};
              co-pong = co.packages.${prev.system}.pong;
            };
          })
        ];
      };
      channelsConfig = { allowUnfree = true; };

      hostDefaults.modules = [
        ./configuration.nix home-manager.nixosModules.home-manager nixpkgs.nixosModules.notDetected
      ];

      hosts = {
        wsl2.modules = [
          ./machines/wsl2

          nix-ld.nixosModules.nix-ld

          ({ pkgs, ... }: {
            environment.systemPackages = [ pkgs.fup-repl ];
          })
        ];

        ceres.modules = [
          ./machines/ceres

          nixpkgs.nixosModules.notDetected
        ];
      };
    };
}
