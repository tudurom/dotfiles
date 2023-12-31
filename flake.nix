{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:nix-community/home-manager/release-23.11";
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

  outputs = inputs@{ self, haumea, nixpkgs, deploy-rs, unstable, flake-parts, ... }:
    let
      vars = {
        stateVersion = "23.11";
        username = "tudor";
      };

      specialArgs = {
        inherit vars;
        flake = {
          inherit self inputs;
        };
      };
    in flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      flake = {
        lib = haumea.lib.load {
          src = ./lib;
          inputs = {
            inherit nixpkgs inputs;
          };
        };

        nixosConfigurations = let
          mkNixOSSystem = name: system: let
            modules = [
              {
                nixpkgs = {
                  config = self.lib.nixpkgs.defaultConfig;
                  overlays = self.lib.nixpkgs.mkDefaultOverlays { inherit system; };
                };
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
                  extraSpecialArgs = specialArgs // { configName = name; };
                  sharedModules = self.lib.hm-modules;
                };
              }
              ./hosts/${name}
            ];
          in nixpkgs.lib.nixosSystem {
            inherit system modules specialArgs;
          };
        in {
          "ceres" = mkNixOSSystem "ceres" "x86_64-linux";
          "wsl2" = mkNixOSSystem "wsl2" "x86_64-linux";
        };

        packages."x86_64-linux"."tudor" = self.homeConfigurations."tudor".activationPackage;
        packages."x86_64-linux"."tudor@pepper-penguin" = self.homeConfigurations."tudor@pepper-penguin".activationPackage;

        homeConfigurations = let
          mkHomeConfiguration = name: user: system: let
            pkgs = self.lib.nixpkgs.mkPkgs { inherit system; };
          in inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            extraSpecialArgs = specialArgs // { configName = "normal-linux"; };
            modules = (self.lib.hm-modules) ++ [
              {
                nixpkgs = {
                  config = self.lib.nixpkgs.defaultConfig;
                  overlays = self.lib.nixpkgs.mkDefaultOverlays { inherit system; };
                };
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
        in {
          "tudor" = mkHomeConfiguration "tudor" "tudor" "x86_64-linux";
          "tudor@pepper-penguin" = mkHomeConfiguration "tudor@pepper-penguin" "tudor" "x86_64-linux";
        };

        deploy.nodes."ceres" = let
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
          configuration = self.nixosConfigurations."ceres";
        in {
          hostname = "ceres.lamb-monitor.ts.net";
          profiles.system = {
            user = "root";
            path = (mkDeployPkgs configuration.pkgs.system).deploy-rs.lib.activate.nixos configuration;
          };
        };
      };

      perSystem = {config, pkgs, system, self', ... }: let
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
        apps.deploy-rs = {
          type = "app";
          program = "${deployPkgs.deploy-rs.deploy-rs}/bin/deploy";
        };

        packages.default = pkgs.nix;
        packages.home-manager = pkgs.home-manager;
        packages.nixos-rebuild = pkgs.nixos-rebuild;
        packages.agenix = inputs.agenix.packages.${system}.default;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix
            home-manager
            nixos-rebuild
            self'.packages.agenix
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
