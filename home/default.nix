{ sources ? import ../nix/sources.nix {}, pkgs ? import sources.nixpkgs { }, config
, lib, options, ... }: {
  imports = [ ../machines/current.nix ./desktop ./hax ./langs ./shell ./tools ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tudor";
  home.homeDirectory = "/home/tudor";
  home.language.base = "ro_RO.UTF-8";
  home.language.time = "ro_RO.UTF-8";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  nixpkgs.overlays = import ../packages;
  nixpkgs.config.allowUnfree = true;

  home.activation.linkStuff = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    test -L $HOME/.doom.d || ln -sf "${builtins.toPath ../config/doom}" "$HOME/.doom.d"

    test -L $HOME/wallpapers || ln -sf "${builtins.toPath ../misc/wallpapers}" "$HOME/wallpapers"

    test -L $HOME/bin || ln -sf "${builtins.toPath ../bin}" "$HOME/bin"
  '';
}
