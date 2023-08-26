{ config, options, lib, inputs, pkgs, ... }:
let
  cfg = config.homeModules.desktop.fonts;
in
with lib; {
  options = {
    homeModules.desktop.fonts = {
      enable = mkEnableOption "Enable fonts";
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [ pkgs.noto-fonts-emoji ];
    xdg.configFile."fontconfig/conf.d/20-noto-emoji.conf".text = ''
    <?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
     <alias>
      <family>serif</family>
      <prefer>
       <family>Noto Sans</family>
       <family>Noto Color Emoji</family>
      </prefer>
     </alias>
     <alias>
      <family>sans-serif</family>
      <prefer>
       <family>Noto Sans</family>
       <family>Noto Color Emoji</family>
      </prefer>
     </alias>
     <alias>
      <family>monospace</family>
      <prefer>
       <family>Noto Sans</family>
       <family>Noto Color Emoji</family>
      </prefer>
     </alias>
     <dir>~/.fonts</dir>
    </fontconfig>
    '';
  };
}
