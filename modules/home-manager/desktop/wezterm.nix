{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.desktop.wezterm;
  inherit (config.homeModules.desktop.fonts) themeFont;
in
with lib; {
  options = {
    homeModules.desktop.wezterm = {
      enable = mkEnableOption "Enable wezterm";
    };
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = pkgs.wezterm;
      extraConfig = ''
        local wezterm = require "wezterm"

        local config = wezterm.config_builder()

        config.font = wezterm.font('${themeFont.family}')
        config.font_size = ${builtins.toString themeFont.size}

        config.hide_tab_bar_if_only_one_tab = true

        config.window_padding = {
          left = "30px",
          right = "30px",
          top = "30px",
          bottom = "30px",
        }

        -- https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html
        function get_appearance()
          if wezterm.gui then
            return wezterm.gui.get_appearance()
          end
          return 'Dark'
        end

        function scheme_for_appearance(appearance)
          if appearance:find 'Dark' then
            return 'GruvboxDark'
          else
            -- for some reason the version of wezterm in nixpkgs
            -- doesn't have 'GruvboxLight'
            return 'Gruvbox (Gogh)'
          end
        end

        config.color_scheme = scheme_for_appearance(get_appearance())

        -- TODO: remove this after it's fixed
        config.default_gui_startup_args = {'start', '--always-new-process'}

        return config
      '';
    };
  };
}
