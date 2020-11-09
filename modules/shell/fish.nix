{ config, lib, pkgs, ... }: {
  tudor.home = {
    home.packages = with pkgs; [
      htop
      fd
      tree
      toilet
      curl
    ];

    programs.fish = {
      enable = true;

      shellAliases = {
        ls = "ls --color=auto -F";
        ll = "ls --color=auto -alF";
        rm = "rm -I";
        clip = "wl-copy";
        poweroff = "systemctl poweroff";
        reboot = "systemctl reboot";
      };

      functions = {
        ghclone = "git clone git@github.com:$argv[1] $argv[2]";
        paw = "pkill -f telegram-desktop"; # don't judge
        transfer = ''
          set -l tmpfile (mktemp -t transferXXX)
          curl --progress-bar --upload-file $argv[1] 'https://transfer.sh/'(basename $argv[1]) > $tmpfile
          cat $tmpfile
          rm -f $tmpfile
        '';
      };

      interactiveShellInit = ''
        eval (${pkgs.direnv}/bin/direnv hook fish)
      '';
    };
  };
}
