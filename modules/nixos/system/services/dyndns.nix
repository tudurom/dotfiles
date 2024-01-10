{ config, pkgs, lib, ... }:
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
          # credentials are of the form "domain:token"
          credentials = config.age.secrets.dedyn.path;
          curl = lib.getExe pkgs.curl;
        in ''
          set -euo pipefail
          IPV4="$(${curl} --fail-with-body 'https://${checkip4}')"
          IPV6="$(${curl} --fail-with-body 'https://${checkip6}')"
          ${curl} --user "$(<"$CREDENTIALS_PATH")" "https://${updateUrl}/?myipv4=$IPV4&myipv6=$IPV6"
        '';

        serviceConfig = {
          Type = "oneshot";
          DynamicUser = "yes";
          LoadCredential = "credentials:${config.age.secrets.dedyn.path}";
          Environment = "CREDENTIALS_PATH=%d/credentials";

          # Hardening
          CapabilityBoundingSet = [ "" ];
          DeviceAllow = [ "" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "~@privileged" ];
          UMask = "0077";
        };
      };
    };
  };
}
