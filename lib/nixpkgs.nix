{ self, inputs, ... }:
{
  defaultConfig = {
    allowUnfree = true;
  };

  mkDefaultOverlays = { system }: [
    (final: prev: {
      unstable = import inputs.unstable {
        inherit system;
        inherit (final) config;
      };
    })
  ];

  mkPkgs = { system }: import inputs.nixpkgs {
    inherit system;
    config = self.defaultConfig;
    overlays = self.mkDefaultOverlays { inherit system; };
  };
}
