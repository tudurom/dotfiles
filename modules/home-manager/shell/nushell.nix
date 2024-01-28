{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.homeModules.shell.nushell;
in {
  options.homeModules.shell.nushell = {
    enable = mkEnableOption "Nushell";
    lightTheme = mkEnableOption "Nushell light theme";
  };

  config = mkIf cfg.enable {
    # for completions. yes.
    programs.fish.enable = true;
    programs.nushell = {
      enable = true;
      extraConfig =
        ''
          $env.config = {
            show_banner: false
          }

          # https://www.nushell.sh/cookbook/external_completers.html#fish-completer
          let fish_completer = {|spans|
            ${lib.getExe pkgs.fish} --command $'complete "--do-complete=($spans | str join " ")"'
            | $"value(char tab)description(char newline)" + $in
            | from tsv --flexible --no-infer
          }

          $env.config.completions = {
            algorithm: "fuzzy"
            external: {
              enable: true
              completer: $fish_completer
            }
          }
        ''
        + (
          if cfg.lightTheme
          then ''
            # https://github.com/nushell/nushell/blob/5ac5b90aed907aaaa3fa4a10159eaddd5562bb5c/crates/nu-utils/src/sample_config/default_config.nu#L72-L133
            let light_theme = {
                # color for nushell primitives
                separator: dark_gray
                leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
                header: green_bold
                empty: blue
                # Closures can be used to choose colors for specific values.
                # The value (in this case, a bool) is piped into the closure.
                # eg) {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
                bool: dark_cyan
                int: dark_gray
                filesize: cyan_bold
                duration: dark_gray
                date: purple
                range: dark_gray
                float: dark_gray
                string: dark_gray
                nothing: dark_gray
                binary: dark_gray
                cellpath: dark_gray
                row_index: green_bold
                record: white
                list: white
                block: white
                hints: dark_gray
                search_result: {fg: white bg: red}
                shape_and: purple_bold
                shape_binary: purple_bold
                shape_block: blue_bold
                shape_bool: light_cyan
                shape_closure: green_bold
                shape_custom: green
                shape_datetime: cyan_bold
                shape_directory: cyan
                shape_external: cyan
                shape_externalarg: green_bold
                shape_filepath: cyan
                shape_flag: blue_bold
                shape_float: purple_bold
                # shapes are used to change the cli syntax highlighting
                shape_garbage: { fg: white bg: red attr: b}
                shape_globpattern: cyan_bold
                shape_int: purple_bold
                shape_internalcall: cyan_bold
                shape_list: cyan_bold
                shape_literal: blue
                shape_match_pattern: green
                shape_matching_brackets: { attr: u }
                shape_nothing: light_cyan
                shape_operator: yellow
                shape_or: purple_bold
                shape_pipe: purple_bold
                shape_range: yellow_bold
                shape_record: cyan_bold
                shape_redirection: purple_bold
                shape_signature: green_bold
                shape_string: green
                shape_string_interpolation: cyan_bold
                shape_table: blue_bold
                shape_variable: purple
                shape_vardecl: purple
            }
            $env.config.color_config = $light_theme
          ''
          else ""
        );
    };

    programs.direnv.enableNushellIntegration = true;
  };
}
