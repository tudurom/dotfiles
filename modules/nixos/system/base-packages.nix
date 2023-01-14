{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.systemModules.basePackages;
  home-manager-package = (import inputs.home-manager { inherit pkgs; }).home-manager;
in
{
  options.systemModules.basePackages = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      bind
      binutils
      coreutils
      curl
      dos2unix
      fd
      file
      htop
      inetutils
      iproute2
      jq
      openssl
      ripgrep
      tmux
      tree
      unrar
      unzip
      neovim
      wget
      zip
      zlib
    ];
  };
}
