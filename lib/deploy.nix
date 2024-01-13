{ inputs, ... }: let
  nixpkgs = inputs.nixpkgs;
  deploy-rs = inputs.deploy-rs;
in {  
  mkPkgs = system: import nixpkgs {
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
}
