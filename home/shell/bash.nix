{ config, pkgs, ... }: {
  programs.bash = {
    enable = true;
    initExtra = ''
      # start fish if interactive
      if [[ $(basename "$(ps --no-header --pid=$PPID --format=cmd)") != "fish" ]]; then
        [[ -z "$BASH_EXECUTION_STRING" ]] && exec ${pkgs.fish}/bin/fish
      fi

      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';

    #profileExtra = ''
    #  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    #'';
  };
}
