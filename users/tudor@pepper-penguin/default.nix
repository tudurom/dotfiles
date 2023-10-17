{ ... }:
{
  imports = [ ../tudor ];

  homeModules = {
    tools = {
      git.opCommitSign = true;
    };
    shell.starship.enable = true;
    
    desktop = {
      foot.enable = true;
      fonts.enable = true;
      nixgl.enable = true;
      sway = {
        enable = true;
        nixGLSupport = true;
        outputs = {
          "LG Electronics LG HDR 4K 0x0000D901" = {
            pos = "0 0";
            scale = "2";
          };
          "BOE 0x09DE Unknown" = {
            pos = "1920 0";
          };
        };
      };
      waybar.enable = true;
    };
  };

  services.kanshi = {
    enable = true;
    profiles = let
      laptopScreen = {
        criteria = "eDP-1";
        scale = 1.25;
      };
      monitor1 = {
        criteria = "LG Electronics LG HDR 4K 0x0000D901";
        scale = 2.0;
      };
      withPos = mon: pos: mon // { position = pos; };
    in {
      undocked = {
        outputs = [
          (withPos laptopScreen "0,0")
        ];
      };
      docked = {
        outputs = [
          (withPos laptopScreen "1920,0")
          (withPos monitor1 "0,0")
        ];
      };
    };
  };
}
