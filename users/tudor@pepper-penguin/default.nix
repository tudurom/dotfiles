{ ... }:
{
  imports = [ ../tudor ];

  homeModules = {
    desktop.nixgl.enable = true;
  };
}
