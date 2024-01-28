{
  config,
  pkgs,
  lib,
  flake,
  ...
}: let
  cfg = config.systemModules.services.pong;
in
  with lib; {
    options.systemModules.services.pong = {
      enable = mkEnableOption "telnet pong";
    };

    config = mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          tudor =
            {
              inherit (flake.inputs.co-work.packages.${final.system}) pong;
            }
            // optionalAttrs (prev ? "tudor") prev.tudor;
        })
      ];

      networking.firewall.allowedTCPPorts = [42069];
      systemd.services.pong = {
        enable = true;
        description = "telnet pong";
        wants = ["network.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = flake.self.lib.harden {
          Restart = "on-failure";
          ExecStart = "${pkgs.tudor.pong}/bin/pong";
          DynamicUser = "yes";
        };
      };
    };
  }
