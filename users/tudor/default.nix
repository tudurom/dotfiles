{ config, options, lib, pkgs, inputs, vars, ... }:
{
  imports = [
    ../_all
  ];

  homeModules = {
    shell.nushell = {
      enable = true;
      lightTheme = true;
    };
    shell.bash = {
      enable = true;
      execOtherShell = true;
      shellToExecPackage = config.programs.nushell.package;
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
