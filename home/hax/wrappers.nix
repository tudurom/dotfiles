{ config, pkgs, lib, options, ... }:
with lib;
let
  cfg = config.my.hax;
  sources = import ../../nix/sources.nix { };
  nixGL = import sources.nixGL { };
  makeWrapper = (noFontconfig: prog:
    let progBaseName = baseNameOf (builtins.unsafeDiscardStringContext prog);
    in (pkgs.runCommand (progBaseName + "-wrapper") {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      meta.priority = -10;
    } ''
      mkdir -p $out/bin
      makeWrapper ${nixGL.nixGLDefault}/bin/nixGL $out/bin/${progBaseName} --add-flags ${prog} \
        ${if noFontconfig then "" else "--set FONTCONFIG_FILE ${pkgs.fontconfig.out}/etc/fonts/fonts.conf"} \
        --set LOCALE_ARCHIVE /usr/lib/locale/locale-archive --set TERMINFO /usr/share/terminfo
    ''));
in {
  options.my.hax = {
    wrappers = with types; lib.mkOption { type = (listOf str); };
    glWrappers = with types; lib.mkOption { type = (listOf str); };
  };

  config.home.packages = (map (makeWrapper false) cfg.wrappers) ++ (map (makeWrapper true) cfg.glWrappers);
}
