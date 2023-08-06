{ ... }:
{
  imports = [ ../tudor ];

  homeModules = {
    tools = {
      git.opCommitSign = true;
    };
    
    desktop = {
      alacritty.enable = true;
      foot.enable = true;
      fonts.enable = true;
      nixgl.enable = true;
      hyprland.enable = true;
      hyprland.nixGLSupport = true;
      waybar.enable = true;
      waybar.hyprland = true;
    };
  };
}
