{
  pkgs,
  flake,
  ...
}: let
  nixGLPackage = pkgs.nixgl.nixGLIntel;
  laptopScreen = {
    criteria = "eDP-1";
    scale = 1.25;
  };
  monitor1 = {
    criteria = "LG Electronics LG HDR 4K 0x00003A3A";
    scale = 2.0;
    transform = "90";
  };
  monitor2 = {
    criteria = "LG Electronics LG HDR 4K 0x0000D901";
    scale = 2.0;
  };
in {
  imports = [../tudor];
  nixpkgs.overlays = [
    flake.inputs.nixgl.overlays.default
  ];

  home.packages = [nixGLPackage];

  homeModules = {
    tools = {
      nix.installAttic = true;
      git.opCommitSign = true;
    };
    shell.starship.enable = true;
    desktop = {
      disableAnimations.enable = true;
      fonts.themeFont = {
        family = "Berkeley Mono";
        style = "Regular";
        size = 12.0;
      };
      sway = {
        inherit nixGLPackage;

        enable = true;
        terminal = "wezterm";
      };
    };
  };

  services.kanshi = {
    enable = true;
    profiles = let
      withPos = mon: x: y: mon // {position = "${builtins.toString x},${builtins.toString y}";};
    in {
      undocked = {
        outputs = [
          (withPos laptopScreen 0 0)
        ];
      };
      docked = {
        outputs = [
          (withPos monitor1 0 0)
          (withPos monitor2 1080 0)
          (withPos laptopScreen (1920 + 1080) 0)
        ];
      };
    };
  };

  # monitor1 is vertical
  wayland.windowManager.sway.config.output = {
    "${monitor1.criteria}".subpixel = "vrgb";
  };
}
