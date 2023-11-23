{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, deploy-rs, unstable, ... } @ inputs:
    let
      vars = {
        stateVersion = "22.05";
        username = "tudor";
      };

      mkDeployPkgs = system: let
        pkgs = import nixpkgs { inherit system; };
      in import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlay
          (final: prev: {
            deploy-rs = { inherit (pkgs) deploy-rs; lib = prev.deploy-rs.lib; };
          })
        ];
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

      x64Pkgs = mkPkgs nixpkgs "x86_64-linux";
      x64DeployPkgs = mkDeployPkgs "x86_64-linux";
    in
    {
      nixosConfigurations."ceres" = mkNixOSSystem "ceres" "x86_64-linux";
      nixosConfigurations."wsl2" = mkNixOSSystem "wsl2" "x86_64-linux";

      homeConfigurations."tudor" = mkNonNixOSEnvironment "tudor" "tudor" "x86_64-linux";
      homeConfigurations."tudor@pepper-penguin" = mkNonNixOSEnvironment "tudor@pepper-penguin" "tudor" "x86_64-linux";

      packages.x86_64-linux."tudor" = self.homeConfigurations."tudor".activationPackage;
      packages.x86_64-linux."tudor@pepper-penguin" = self.homeConfigurations."tudor@pepper-penguin".activationPackage;

      apps.x86_64-linux.deploy-rs = {
        type = "app";
        program = "${x64DeployPkgs.deploy-rs.deploy-rs}/bin/deploy";
      };

      packages.x86_64-linux.default = x64Pkgs.nix;
      packages.x86_64-linux.home-manager = x64Pkgs.home-manager;
      packages.x86_64-linux.nixos-rebuild = x64Pkgs.nixos-rebuild;
      packages.x86_64-linux.agenix = x64Pkgs.agenix;

      devShells.x86_64-linux.default = x64Pkgs.mkShell {
        buildInputs = with x64Pkgs; [
          nix
          home-manager
          nixos-rebuild
          agenix
          x64DeployPkgs.deploy-rs.deploy-rs

          nil
        ];
      };

      devShells.x86_64-linux.ansible = x64Pkgs.mkShell {
        buildInputs = with x64Pkgs; [
          ansible
          ansible-lint

          python3Packages.pip
        ];
      };

      deploy.nodes."ceres" = {
        hostname = "ceres.lamb-monitor.ts.net";
        profiles.system = {
          sshUser = "root";
          path = x64DeployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations."ceres";
        };
      };

      checks = (builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib) // {
        x86_64-linux.ansible-lint = x64Pkgs.stdenvNoCC.mkDerivation {
          name = "run-ansible-lint";
          src = ./.;
          dontBuild = true;
          doCheck = true;
          buildInputs = with x64Pkgs; [ ansible-lint git ];
          checkPhase = ''
            cd ./ansible
            env HOME=$TMPDIR ansible-lint --offline
          '';
          installPhase = ''
            mkdir "$out"
          '';
        };
      };
    };
}
