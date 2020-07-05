{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.tools.aspell;
in
with lib; {
  options = {
    tudor.tools.aspell = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable spelling dictionaries.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      aspellDicts.ro
    ];

    home.sessionVariables.ASPELL_CONF = "dict-dir $HOME/.nix-profile/lib/aspell";
  };
}
