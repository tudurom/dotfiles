{ ... }:
{
  imports = [ ../tudor ];

  homeModules = {
    tools.op.wsl2Magic = true;
    shell.starship.enable = true;
  };
}
