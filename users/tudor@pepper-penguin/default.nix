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
    profiles = {
      undocked = {
        outputs = [{
          criteria = "eDP-1";
          position = "0,0";
        }];
      };
      docked = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "1920,0";
          }
          {
            criteria = "LG Electronics LG HDR 4K 0x0000D901";
            position = "0,0";
            scale = 2.0;
          }
        ];
      };
    };
  };
}
