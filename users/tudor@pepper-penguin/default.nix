{ ... }:
{
  imports = [ ../tudor ];

  homeModules = {
    desktop = {
      nixgl.enable = true;
      hyprland.enable = true;
      hyprland.nixGLSupport = true;
    };
  };
}
