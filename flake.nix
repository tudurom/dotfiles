{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:rycee/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
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

    co-work.url = "git+ssh://git@github.com/tudurom/co-work.git";
    site.url = github:tudurom/site;
    blog.url = github:tudurom/blog;
  };

  outputs = { self, nixpkgs, co-work, ... } @ inputs:
    let
      vars = {
        stateVersion = "22.05";
        emacs = "emacsPgtkNativeComp";
      };
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.emacs-overlay.overlay
	  (final: prev: {
            tudor.site = inputs.site.packages.${system}.site;
            tudor.blog = inputs.blog.packages.${system}.blog;
          })
        ];
      };
      mkNixOSModules = name: system: [
        {
          nixpkgs.pkgs = mkPkgs system;
          _module.args.nixpkgs = nixpkgs;
          _module.args.self = self;
          _module.args.inputs = inputs;
          _module.args.configName = name;
          _module.args.vars = vars;
        }
        inputs.home-manager.nixosModules.home-manager
        inputs.nixos-wsl.nixosModules.wsl
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            extraSpecialArgs = { inherit inputs vars; };
          };
        }
        ./hosts/${name}
      ];
      mkNixOSSystem = name: system: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = mkNixOSModules name system;
      };
      mkNonNixOSEnvironment = name: user: system: inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs system;
        modules = [
          {
            _module.args.nixpkgs = nixpkgs;
            _module.args.inputs = inputs;
            _module.args.vars = vars;
          }
          {
            home = {
              homeDirectory = "/home/${user}";
              username = user;
            };
          }
          (./users + "/${name}" + /home.nix)
        ];
      };
    in
    {
      nixosConfigurations."ceres" = mkNixOSSystem "ceres" "x86_64-linux";
      nixosConfigurations."wsl2" = mkNixOSSystem "wsl2" "x86_64-linux";

      homeConfigurations."tudor" = mkNonNixOSEnvironment "tudor" "tudor" "x86_64-linux";
      packages.x86_64-linux."tudor" = self.homeConfigurations."tudor".activationPackage;

      defaultPackage.x86_64-linux = (mkPkgs "x86_64-linux").nix;
    };
}
