{ config, options, lib, inputs, pkgs, ... }:
let
  cfg = config.homeModules.desktop.foot;
in
with lib; {
  options = {
    homeModules.desktop.foot = {
      enable = mkEnableOption "Enable foot";
    };
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          pad = "20x20";
          # idk how foot does font sizes but it's not as
          # small as you might think
          font = "Berkeley Mono:size=10";
          dpi-aware = "yes";
        };
        colors = {
          # https://codeberg.org/dnkl/foot/src/branch/master/themes/gruvbox-light
          background = "fbf1c7";
          foreground = "3c3836";
          regular0 = "fbf1c7";
          regular1 = "cc241d";
          regular2 = "98971a";
          regular3 = "d79921";
          regular4 = "458588";
          regular5 = "b16286";
          regular6 = "689d6a";
          regular7 = "7c6f64";
          bright0 = "928374";
          bright1 = "9d0006";
          bright2 = "79740e";
          bright3 = "b57614";
          bright4 = "076678";
          bright5 = "8f3f71";
          bright6 = "427b58";
          bright7 = "3c3836";
        };
      };
    };
  };
}
