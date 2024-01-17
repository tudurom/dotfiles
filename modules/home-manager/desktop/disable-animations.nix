{ config, lib, ... }: let
  cfg = config.homeModules.desktop.disableAnimations;
in
with lib; {
  options = {
    homeModules.desktop.disableAnimations = {
      enable = mkEnableOption "Enable disabling of animations";
    };
  };

  config = mkIf cfg.enable {
    gtk = let
      extraConfig.gtk-enable-animations = false;
    in {
      enable = true;
      gtk3 = { inherit extraConfig; };
      gtk4 = { inherit extraConfig; };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface".enable-animations = false;
      };
    };
  };
}
