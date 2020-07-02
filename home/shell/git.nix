{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "Tudor Roman";
    userEmail = "tudor@tudorr.ro";

    signing.key = "58359B0A5EEF806EBCBCDFCE5AFEDD03CA5A1EA4";
    signing.signByDefault = true;

    aliases = {
      graph = ''
        log --graph --color --pretty=format:"%C(yellow)%H%C(green)%d%C(reset)%n%x20%cd%n%x20%cn%x20(%ce)%n%x20%s%n"
              '';
    };

    extraConfig = {
      credential.helper = "!bw-git-helper $@";
      diff.algorithm = "patience";
      tag.forceSignAnnotated = true;
    };
  };
}
