{inputs, ...}: let
  inherit (inputs) nixpkgs deploy-rs;
in {
  mkPkgs = system:
    import nixpkgs {
      inherit system;
      overlays = [
        deploy-rs.overlay
        (_self: super: {
          deploy-rs = {
            inherit (nixpkgs.legacyPackages."${system}") deploy-rs;
            inherit (super.deploy-rs) lib;
          };
        })
      ];
    };
}
