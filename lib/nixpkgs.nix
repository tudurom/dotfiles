{
  self,
  inputs,
  nixpkgs,
  ...
}: {
  defaultConfig = {
    allowUnfree = true;
  };

  mkDefaultOverlays = {system}: [
    (final: _prev: {
      unstable = import inputs.unstable {
        inherit system;
        inherit (final) config;
      };
    })
  ];

  mkPkgs = {
    nixpkgsVersion ? nixpkgs,
    system,
  }:
    import nixpkgsVersion {
      inherit system;
      config = self.defaultConfig;
      overlays = self.mkDefaultOverlays {inherit system;};
    };
}
