{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeModules.desktop.fonts;
in
  with lib; {
    options = {
      homeModules.desktop.fonts = {
        enable = mkEnableOption "Enable fonts";
        themeFont = mkOption {
          default = {};
          type = types.submodule ({...}: {
            options = {
              family = mkOption {
                type = types.str;
                default = "monospace";
                example = "Fira Mono";
              };
              style = mkOption {
                type = types.str;
                default = "";
                example = "Bold Semi-Condensed";
              };
              size = mkOption {
                type = types.float;
                default = 12.0;
              };
            };
          });
        };
      };
    };

    config = mkIf cfg.enable {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
      ];

      # credits: https://github.com/androlabs/emoji-archlinux
      xdg.configFile."fontconfig/conf.d/20-noto-emoji.conf".text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
         <alias>
           <family>sans-serif</family>
           <prefer>
             <family>Noto Sans</family>
             <family>Noto Color Emoji</family>
             <family>Noto Emoji</family>
             <family>DejaVu Sans</family>
           </prefer>
         </alias>

         <alias>
           <family>serif</family>
           <prefer>
             <family>Noto Serif</family>
             <family>Noto Color Emoji</family>
             <family>Noto Emoji</family>
             <family>DejaVu Serif</family>
           </prefer>
         </alias>

         <alias>
          <family>monospace</family>
          <prefer>
            <family>Noto Sans Mono</family>
            <family>Noto Color Emoji</family>
            <family>Noto Emoji</family>
           </prefer>
         </alias>
        </fontconfig>
      '';
    };
  }
