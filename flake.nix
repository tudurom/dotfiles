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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yarr-nix = {
      url = "git+https://git.tudorr.ro/tudor/yarr-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    co-work.url = "git+ssh://gitea@git.tudorr.ro/tudor/assignments.git?dir=co";
  };

  outputs = inputs@{ self, haumea, nixpkgs, deploy-rs, unstable, flake-parts, home-manager, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];

      vars = {
        stateVersion = "23.11";
      };

      specialArgs = {
        inherit vars;
        flake = {
          inherit self inputs;
        };
      };

      deployPkgs = with nixpkgs.lib; listToAttrs (map (system: nameValuePair system (self.lib.deploy.mkPkgs system)) systems);
    in flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;

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
              inputs.agenix.nixosModules.default
              {
                environment.systemPackages = [ inputs.agenix.packages.${system}.default ];
                # enable ssh host key generation
                services.openssh.enable = true;
              }

              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = false;
                  extraSpecialArgs = specialArgs;
                  sharedModules = self.lib.hm-modules;
                };
              }
              ./hosts/${name}
            ];
          in nixpkgs.lib.nixosSystem {
            pkgs = self.lib.nixpkgs.mkPkgs { inherit system; };
            inherit system modules specialArgs;
          };
        in {
          "ceres" = mkNixOSSystem "ceres" "x86_64-linux";
          "wsl2" = mkNixOSSystem "wsl2" "x86_64-linux";
        };

        homeConfigurations = let
          mkHomeConfiguration = name: user: system: let
            pkgs = self.lib.nixpkgs.mkPkgs { inherit system; };
          in inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            extraSpecialArgs = specialArgs;
            modules = (self.lib.hm-modules) ++ [
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
          cfg = self.nixosConfigurations."ceres";
        in {
          hostname = "ceres.lamb-monitor.ts.net";
          profiles.system = {
            user = "root";
            path = deployPkgs.${cfg.pkgs.system}.deploy-rs.lib.activate.nixos cfg;
          };
        };

        checks."x86_64-linux" = deployPkgs."x86_64-linux".deploy-rs.lib.deployChecks self.deploy;
      };

      perSystem = {config, pkgs, system, self', ... }: {
        packages.default = pkgs.nix;
        packages.nixos-rebuild = pkgs.nixos-rebuild;

        packages.home-manager = inputs.home-manager.packages.${system}.default;
        packages.agenix = inputs.agenix.packages.${system}.default;

        packages.deploy-rs = deployPkgs.${system}.deploy-rs.deploy-rs;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix

            self'.packages.home-manager
            self'.packages.nixos-rebuild
            self'.packages.agenix
            self'.packages.deploy-rs

            nil
          ];
        };

        checks = {
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
