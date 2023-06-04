{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.tools.git;
in
with lib; {
  options = {
    homeModules.tools.git = {
      enable = mkEnableOption "Enable Git config";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      userName = "Tudor Roman";
      userEmail = "tudor@tudorr.ro";

      aliases = {
        graph = ''
          log --graph --color --pretty=format:"%C(yellow)%H%C(green)%d%C(reset)%n%x20%cd%n%x20%cn%x20(%ce)%n%x20%s%n"
        '';
      };

      extraConfig = {
        user.signingkey = removeSuffix "\n" (builtins.readFile ../../../id_ed25519.pub);
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        commit.gpgsign = true;
      };
    };

    home.file.".ssh/allowed_signers".text = ''
      * ${builtins.readFile ../../../id_ed25519.pub}
    '';

    home.packages = with pkgs; [
      git-lfs
    ];
  };
}
