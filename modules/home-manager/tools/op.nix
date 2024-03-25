{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeModules.tools.op;
in
  with lib; {
    options = {
      homeModules.tools.op = {
        enable = mkEnableOption "Enable 1Password CLI";
        bashInitExtra = mkOption {
          type = types.str;
          description = "Lines to prepend in .bashrc for WSL";
          visible = false;
          default = "";
        };
        wsl2Magic = mkEnableOption "Enable WSL2 magic";
      };
    };

    config = mkMerge [
      (mkIf cfg.enable {
        home.packages = with pkgs; [
          _1password
        ];
      })

      (mkIf cfg.wsl2Magic {
        home.shellAliases.op = "op.exe";
        # Acknowledgements: https://stuartleeks.com/posts/wsl-ssh-key-forward-to-windows/
        # God bless your soul
        # Requires npiperelay
        programs.bash.initExtra = let
          inherit (pkgs) ps util-linux socat;
          grep = pkgs.gnugrep;
        in ''
          # Configure ssh forwarding
          export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
          # need `ps -ww` to get non-truncated command for matching
          # use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
          ALREADY_RUNNING=$(${ps}/bin/ps -auxww | ${grep}/bin/grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
          if [[ $ALREADY_RUNNING != "0" ]]; then
              if [[ -S $SSH_AUTH_SOCK ]]; then
                  # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
                  echo "removing previous socket..."
                  rm $SSH_AUTH_SOCK
              fi
              echo "Starting SSH-Agent relay..."
              # setsid to force new session to keep running
              # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
              (${util-linux}/bin/setsid ${socat}/bin/socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
          fi
        '';
      })
    ];
  }
