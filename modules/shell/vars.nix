{ config, pkgs, ... }: {
  tudor.home = {
    # for tput
    home.packages = [ pkgs.ncurses ];
    home.sessionVariables = {
      LS_COLORS = "";
      MAKEFLAGS = "-j$(( $(grep -c processor /proc/cpuinfo) + 2))";
      MANWIDTH = 80;
      SUDO_PROMPT = "[sudo] auth $(tput bold)$(tput setaf 1)%U$(tput sgr0) ";
      #LOCALE_ARCHIVE = "/usr/lib/locale/locale-archive";
      PATH = "$HOME/bin:$PATH";
    };
    #home.sessionPath = [
    #  "$HOME/bin"
    #];
  };
}
