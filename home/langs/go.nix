{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    go
    goimports
    gomodifytags
    gopls
    gotests
    gotools
  ];
}
