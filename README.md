# Tudor's dotfiles

These are configuration files for a system running NixOS.

This configuration supports root erasure on boot, using btrfs. It is disabled by default.

## Installation

For non-NixOS:

1. Install home-manager
3. Clone this repo in `/etc/nixos`.
4. Create password file:
  * If using root erasing, `mkpasswd -m sha-512 | sudo tee /persist/passwds/.$username.passwd`
  * If not, `mkpasswd -m sha-512 | sudo tee /root/passwds/.$username.passwd`
5. `sudo nixos-rebuild switch --flake .#<machine_name>`
