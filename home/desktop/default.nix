{ config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./dirs.nix
    ./fonts.nix
    ./gtk.nix
    ./mako.nix
    ./sway.nix
    ./systemd.nix
    ./zathura.nix
  ];

  xsession.pointerCursor = {
   package = pkgs.capitaine-cursors;
   name = "Capitaine Cursors";
  };

  home.packages = with pkgs; [
    xfce.xfce4-volumed-pulse
    pulseeffects
    redshift-wlr
    dex

    pamixer
    playerctl
    grim
    slurp
    wl-clipboard
  ];
}
