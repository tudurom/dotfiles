{ config, pkgs, lib, flake, ... }:
let
  cfg = config.systemModules.services.dyndns;
in
with lib; {
  options.systemModules.services.dyndns = {
    enable = mkEnableOption "Dynamic DNS Client";
  };

  config = mkIf cfg.enable {
    systemd = {
      timers.dyndns = {
        wantedBy = [ "timers.target" ];
        wants = [ "network-online.target" ];
        partOf = [ "dyndns.service" ];
        timerConfig = {
          OnUnitActiveSec = "15min";
          OnBootSec = "10s";
        };
      };

      services.dyndns = {
        script = let
          checkip4 = "checkipv4.dedyn.io";
          checkip6 = "checkipv6.dedyn.io";
          updateUrl = "update.dedyn.io";
          curl = lib.getExe pkgs.curl;
        in ''
          set -euo pipefail
          IPV4="$(${curl} --fail-with-body 'https://${checkip4}')"
          IPV6="$(${curl} --fail-with-body 'https://${checkip6}')"
          ${curl} --user "$(<"$CREDENTIALS_PATH")" "https://${updateUrl}/?myipv4=$IPV4&myipv6=$IPV6"
        '';

        serviceConfig = flake.self.lib.harden {
          Type = "oneshot";
          DynamicUser = "yes";
          # credentials are of the form "domain:token"
          LoadCredential = "credentials:${config.age.secrets.dedyn.path}";
          Environment = "CREDENTIALS_PATH=%d/credentials";
        };
      };
    };
  };
}
