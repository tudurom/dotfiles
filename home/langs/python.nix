{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    python38
    python38Packages.pip
    python38Packages.ipython
    python38Packages.setuptools
    python38Packages.pylint
  ];
}
