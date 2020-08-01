{ config, lib, pkgs, ... }: {
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

  home.activation.fishCheck = let
    homeDir = config.home.homeDirectory;
    username = config.home.username;
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    alias tput=${pkgs.ncurses}/bin/tput
    test "$("${pkgs.getent}/bin/getent" passwd ${username} | cut -d: -f7)" != "${homeDir}/.nix-profile/bin/fish" \
      && {
        tput bold; tput setaf 1
        echo "Don't forget to chsh to ~/.nix-profile/bin/fish!"
        tput sgr0
      } || echo "fish ok!"
  '';
}
