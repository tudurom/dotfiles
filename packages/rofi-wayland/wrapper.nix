{ symlinkJoin, lib, makeWrapper, hicolor-icon-theme
, pkgs, theme ? null, plugins ? [] }:
let
  rofi-wayland-unwrapped = pkgs.callPackage (import ./default.nix) {};
in symlinkJoin {
  name = "rofi-wayland-${rofi-wayland-unwrapped.version}";

  paths = [
    rofi-wayland-unwrapped.out
  ] ++ (lib.forEach plugins (p: p.out));

  buildInputs = [ makeWrapper ];
  preferLocalBuild = true;
  passthru.unwrapped = rofi-wayland-unwrapped;
  postBuild = ''
    rm -rf $out/bin
    mkdir $out/bin
    ln -s ${rofi-wayland-unwrapped}/bin/* $out/bin

    rm $out/bin/rofi
    makeWrapper ${rofi-wayland-unwrapped}/bin/rofi $out/bin/rofi \
      --prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share \
      ${lib.optionalString (plugins != []) ''--prefix XDG_DATA_DIRS : ${lib.concatStringsSep ":" (lib.forEach plugins (p: "${p.out}/share"))}''} \
      ${lib.optionalString (theme != null) ''--add-flags "-theme ${theme}"''} \
      ${lib.optionalString (plugins != []) ''--add-flags "-plugin-path $out/lib/rofi"''}

    rm $out/bin/rofi-theme-selector
    makeWrapper ${rofi-wayland-unwrapped}/bin/rofi-theme-selector $out/bin/rofi-theme-selector \
      --prefix XDG_DATA_DIRS : $out/share
  '';

  meta = rofi-wayland-unwrapped.meta // {
    priority = (rofi-wayland-unwrapped.meta.priority or 0) - 1;
  };
}
