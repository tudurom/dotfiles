{ config, pkgs, lib, flake, ... }:
let
  cfg = config.systemModules.services.attic;
in
with lib; {
  imports = [
    flake.inputs.attic.nixosModules.atticd
  ];

  options.systemModules.services.attic = {
    enable = mkEnableOption "Attic Nix cache";
    listenPort = mkOption {
      description = "Listen port";
      type = types.int;
      default = 8045;
    };
  };

  config = mkIf cfg.enable {
    services.atticd = {
      enable = true;
      credentialsFile = config.age.secrets.attic-server-token.path;
      settings = {
        listen = "[::]:${builtins.toString cfg.listenPort}";
        # taken from: https://docs.attic.rs/admin-guide/deployment/nixos.html
        chunking = {
          nar-size-threshold = 64 * 1024; # 64 KiB
          min-size = 16 * 1024; # 16 KiB
          avg-size = 64 * 1024; # 64 KiB
          max-size = 256 * 1024; # 256 KiB
        };
      };
    };
  };
}
