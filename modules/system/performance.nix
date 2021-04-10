{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.performance;
in
with lib; {
  options.tudor.performance.enable = mkEnableOption "performance on AC";

  config = mkIf cfg.enable {
    services.acpid.enable = true;
    services.acpid.handlers.ac-power = {
      event = "ac_adapter/*";
      action = let
        cpupower = config.boot.kernelPackages.cpupower;
      in ''
        vals=($1)
        case ''${vals[3]} in
          00000000)
            ${cpupower}/bin/cpupower frequency-set -g schedutil
            ;;
          00000001)
            ${cpupower}/bin/cpupower frequency-set -g performance
            ;;
          *)
            ;;
        esac
      '';
    };
  };
}
