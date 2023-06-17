{ config, pkgs, lib, options, inputs, ... }:
let
  cfg = config.homeModules.desktop.hyprland;
in
with lib; {
  options = {
    homeModules.desktop.hyprland = {
      enable = mkEnableOption "Enable Hyprland";
      nixGLSupport = mkEnableOption "Use NixGL when starting Hyprland";
    };
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = let
        system = pkgs.stdenv.hostPlatform.system;
        nixGL = inputs.nixgl.packages.${system}.default;
        origPkg = inputs.hyprland.packages.${system}.default.override {
          enableXWayland = config.wayland.windowManager.hyprland.xwayland.enable;
          hidpiXWayland = config.wayland.windowManager.hyprland.xwayland.hidpi;
          inherit (config.wayland.windowManager.hyprland) nvidiaPatches;
        };
      in if cfg.nixGLSupport then (pkgs.runCommand "hyprland-nixgl-wrapper" {} ''
        mkdir $out
        ln -s ${origPkg}/* $out
        rm $out/bin
        mkdir $out/bin
        echo "exec ${lib.getExe nixGL} ${origPkg}/bin/Hyprland \$@" > $out/bin/Hyprland
        chmod +x $out/bin/Hyprland
      '') else origPkg;
    };
  };
}
