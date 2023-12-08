{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default-linux";
    utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "";
    };

    home-manager = {
      url = "github:rycee/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nix-alien = {
    #   url = "github:thiagokokada/nix-alien";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
    };

    yarr-nix = {
      url = "git+https://git.tudorr.ro/tudor/yarr-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    co-work.url = "git+ssh://git@github.com/tudurom/co-work.git";
    site.url = "github:tudurom/site";
    blog.url = "github:tudurom/blog";
  };

  outputs = inputs@{ self, nixpkgs, utils, deploy-rs, unstable, flake-parts, ... }:
    let
      vars = {
        stateVersion = "22.05";
        username = "tudor";
      };

      mkPkgs = pkgs: system: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.hypr-contrib.overlays.default
          inputs.nixgl.overlays.default
          inputs.agenix.overlays.default
          inputs.yarr-nix.overlays.default
          (final: prev: {
            tudor.site = inputs.site.packages.${system}.site;
            tudor.blog = inputs.blog.packages.${system}.blog;
            tudor.pong = inputs.co-work.packages.${system}.pong;
            unstable = import inputs.unstable { inherit system; config.allowUnfree = true; };
            home-manager = inputs.home-manager.packages.${system}.home-manager;
          })
        ];
      };

      mkHmDependencies = system: [
        inputs.agenix.homeManagerModules.default
      ];

      mkNixOSModules = name: system: [
        {
          nixpkgs.pkgs = mkPkgs nixpkgs system;
          _module.args.nixpkgs = nixpkgs;
          _module.args.self = self;
          _module.args.inputs = inputs;
          _module.args.configName = name;
          _module.args.vars = vars;
        }
        inputs.agenix.nixosModules.default
        {
          environment.systemPackages = [ inputs.agenix.packages.${system}.default ];
          # enable ssh host key generation
          services.openssh.enable = true;
        }
        inputs.home-manager.nixosModules.home-manager
        inputs.nixos-wsl.nixosModules.wsl
        inputs.yarr-nix.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            extraSpecialArgs = { inherit inputs vars; configName = name; };
            sharedModules = mkHmDependencies system;
          };
        }
        ./hosts/${name}
      ];

      mkNixOSSystem = name: system: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = mkNixOSModules name system;
      };

      mkNonNixOSEnvironment = name: user: system: inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs nixpkgs system;
        extraSpecialArgs = {inherit inputs vars; configName = "normal-linux"; };
        modules = (mkHmDependencies system) ++ [
          {
            _module.args.nixpkgs = nixpkgs;
            _module.args.inputs = inputs;
            _module.args.vars = vars;
          }
          {
            home = {
              homeDirectory = "/home/${user}";
              username = user;
              sessionVariables = {
                GIT_SSH = "/usr/bin/ssh";
              };
            };

            programs.bash.profileExtra = ''
              . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            '';
          }
          (./users + "/${name}")
        ];
      };

      mkDeployPkgs = system: import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlay
          (self: super: {
            deploy-rs = {
              inherit (nixpkgs.legacyPackages."${system}") deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
      };
    in flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      flake = {
        nixosConfigurations."ceres" = mkNixOSSystem "ceres" "x86_64-linux";
        nixosConfigurations."wsl2" = mkNixOSSystem "wsl2" "x86_64-linux";

        packages."x86_64-linux"."tudor" = self.homeConfigurations."tudor".activationPackage;
        packages."x86_64-linux"."tudor@pepper-penguin" = self.homeConfigurations."tudor@pepper-penguin".activationPackage;

        homeConfigurations."tudor" = mkNonNixOSEnvironment "tudor" "tudor" "x86_64-linux";
        homeConfigurations."tudor@pepper-penguin" = mkNonNixOSEnvironment "tudor@pepper-penguin" "tudor" "x86_64-linux";

        deploy.nodes."ceres" = {
          hostname = "ceres.lamb-monitor.ts.net";
          profiles.system = {
            sshUser = "root";
            path = (mkDeployPkgs "x86_64-linux").deploy-rs.lib.activate.nixos self.nixosConfigurations."ceres";
          };
        };
      };

      perSystem = {config, pkgs, system, ... }: let
        deployPkgs = import nixpkgs {
          inherit system;
          overlays = [
            deploy-rs.overlay
            (final: prev: {
              deploy-rs = { inherit (pkgs) deploy-rs; lib = prev.deploy-rs.lib; };
            })
          ];
        };
      in {
        _module.args.pkgs = mkPkgs nixpkgs system;
        apps.deploy-rs = {
          type = "app";
          program = "${deployPkgs.deploy-rs.deploy-rs}/bin/deploy";
        };

        packages.default = pkgs.nix;
        packages.home-manager = pkgs.home-manager;
        packages.nixos-rebuild = pkgs.nixos-rebuild;
        packages.agenix = pkgs.agenix;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix
            home-manager
            nixos-rebuild
            agenix
            deployPkgs.deploy-rs.deploy-rs

            nil
          ];
        };

        checks = (deployPkgs.deploy-rs.lib.deployChecks self.deploy) // {
          ansible-lint = pkgs.stdenvNoCC.mkDerivation {
            name = "run-ansible-lint";
            src = ./.;
            dontBuild = true;
            doCheck = true;
            buildInputs = with pkgs; [ ansible-lint git ];
            checkPhase = ''
              cd ./ansible
              env "HOME=$TMPDIR" ansible-lint --offline
            '';
            installPhase = ''
              mkdir "$out"
            '';
          };
        };
      };
    };
}
