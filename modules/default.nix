{ config, lib, options, pkgs, ... }:
let
  # there must be an elegant way of doing this but I don't know
  hmLib = (import <home-manager/modules/lib/stdlib-extended.nix> pkgs.lib).hm;
in
{
  imports = [
    ./desktop
    ./langs
    ./shell
    ./system
    ./tools
  ];

  options = {
    tudor.home = lib.mkOption {
      type = options.home-manager.users.type.functor.wrapped;
    };
  };

  config = {
    tudor.home = {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      programs.man.generateCaches = true;

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "20.03";

      home.activation.linkStuff = hmLib.dag.entryAfter [ "writeBoundary" ] ''
        test -L $HOME/.doom.d || ln -sf "${builtins.toPath ../config/doom}" "$HOME/.doom.d"

        test -L $HOME/wallpapers || ln -sf "${builtins.toPath ../misc/wallpapers}" "$HOME/wallpapers"

        test -L $HOME/bin || ln -sf "${builtins.toPath ../bin}" "$HOME/bin"
      '';
    };
  };
}
