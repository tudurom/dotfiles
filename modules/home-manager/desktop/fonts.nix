{ config, options, lib, inputs, pkgs, ... }:
let
  cfg = config.homeModules.desktop.fonts;
in
with lib; {
  options = {
    homeModules.desktop.fonts = {
      enable = mkEnableOption "Enable fonts";
      themeFont = mkOption {
        default = {};
        type = types.submodule ({ ... }: {
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
      noto-fonts-emoji
    ];

    xdg.configFile."fontconfig/conf.d/20-noto-emoji.conf".text = ''
    <?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      <alias>
      <family>emoji</family>
      <prefer>
        <family>Noto Color Emoji</family>
      </prefer>
      </alias>

      <alias binding="weak">
        <family>serif</family>
        <prefer>
          <family>emoji</family>
        </prefer>
      </alias>

      <alias binding="weak">
        <family>sans-serif</family>
        <prefer>
          <family>emoji</family>
        </prefer>
      </alias>

      <alias binding="weak">
        <family>monospace</family>
        <prefer>
          <family>emoji</family>
        </prefer>
      </alias>
    </fontconfig>
    '';
  };
}
