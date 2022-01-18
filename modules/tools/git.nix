{ config, lib, pkgs, ... }: {
  tudor.home = {
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

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
        # FIXME: bit bitwarden credential helper
        #credential.helper = "!bw-git-helper $@";
        diff.algorithm = "patience";
        tag.forceSignAnnotated = true;
      };
    };


    xdg.configFile."bw-git-helper/config.ini".text = ''
    [config]
    pinentry=pinentry-gnome3

    [smtp.gmail.com:587]
    target=24e3234d-cac8-4d1a-8cee-490634ff2f14
    '';

    home.packages = with pkgs; [
      #tudor.bw-git-helper
      git-lfs
    ];
  };
}
