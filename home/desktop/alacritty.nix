{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      window.padding = { x = 20; y = 20; };

      font = let
        fontSetting = {
          family = "Go Mono";
          style = "Regular";
        };
      in {
        normal = fontSetting;
        bold = fontSetting;
        italic = fontSetting;

        size = 14.0;
      };

      colors = {
        primary = {
          background = "0xfbf1c7";
          foreground = "0x3c3836";
        };

        normal = {
          black = "0xfbf1c7";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0x7c6f64";
        };

        bright = {
          black = "0x928374";
          red = "0x9d0006";
          green = "0x79740e";
          yellow = "0xb57614";
          blue = "0x076678";
          magenta = "0x8f3f71";
          cyan = "0x427b58";
          white = "0x3c3836";
        };
      };
    };
  };
  my.hax.wrappers = [ "${pkgs.alacritty}/bin/alacritty" ];
  home.packages = [ pkgs.go-font ];
}
