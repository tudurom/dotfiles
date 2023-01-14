{ config, options, lib, pkgs, inputs, vars, ... }:
{
  imports = [
    ../_all
  ];

  homeModules = {
    shell.fish.enable = true;
    shell.bash = {
      enable = true;
      execFish = true;
    };

    tools = {
      aspell.enable = true;
      direnv.enable = true;
      git.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
      };
    };
  };
}
