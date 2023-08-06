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
      base.enable = true;

      aspell.enable = true;
      direnv.enable = true;
      git.enable = true;
      neovim = {
        enable = true;
        defaultEditor = false;
      };
      nix.enable = true;
      hx = {
        enable = true;
        defaultEditor = true;
      };
      op = {
        enable = true;
      };
      tmux.enable = true;
    };
  };
}
