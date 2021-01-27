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
      action = ''
        vals=($1)
        case ''${vals[3]} in
          00000000)
            echo unplugged >> /tmp/acpi.log
            ;;
          00000001)
            echo plugged in >> /tmp/acpi.log
            ;;
          *)
            echo unknown >> /tmp/acpi.log
            ;;
        esac
      '';
    };
  };
}
