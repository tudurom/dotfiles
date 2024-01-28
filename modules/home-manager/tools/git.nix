{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeModules.tools.git;
in
  with lib; {
    options = {
      homeModules.tools.git = {
        enable = mkEnableOption "Enable Git config";
        opCommitSign = mkEnableOption "Enable commit signing with SSH keys from 1Password";
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

        extraConfig =
          {
            push.autoSetupRemote = true;
          }
          // (
            if cfg.opCommitSign
            then {
              user.signingkey = removeSuffix "\n" (builtins.readFile ../../../id_ed25519.pub);
              gpg.format = "ssh";
              gpg.ssh.program = "/opt/1Password/op-ssh-sign";
              commit.gpgsign = true;
            }
            else {}
          );
      };

      home.file.".ssh/allowed_signers".text = ''
        * ${builtins.readFile ../../../id_ed25519.pub}
      '';

      home.packages = with pkgs; [
        git-lfs
      ];
    };
  }
