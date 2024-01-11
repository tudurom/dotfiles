{ config, pkgs, lib, flake, ... }:
let
  cfg = config.systemModules.services.pong;
in
with lib;
{
  options.systemModules.services.pong = {
    enable = mkEnableOption "telnet pong";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        tudor = {
          pong = flake.inputs.co-work.packages.${final.system}.pong;
        } // optionalAttrs (prev ? "tudor") prev.tudor;
      })
    ];

    networking.firewall.allowedTCPPorts = [ 42069 ];
    systemd.services.pong = {
      enable = true;
      description = "telnet pong";
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${pkgs.tudor.pong}/bin/pong";
        DynamicUser = "yes";
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
}
