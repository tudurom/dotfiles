# Tudor's Dotfiles / Nix configuration

This is my Nix configuration, which works both for NixOS and for Nix

Acknowledgements to https://github.com/mrkuz/nixos for heavily inspiring the layout of this config.

> **Warning**
> The configuration codified here was made to be used by me and only me.
> While I am publishing them to help others to learn Nix and dotfile management,
> copying them verbatim will likely produce an unusable system.

## Installation

### NixOS

First, provision a machine with NixOS.

Then:

Desktop:
1. Clone this repo somewhere on the machine.
2. `nix run .#nixos-rebuild -- boot --flake .#<hostname> --use-remote-sudo`

Remote server:
1. `nix run .#deploy-rs -- .#<hostname>`

### Any other Linux distro for sane people

1. Provision a machine with a "normal" Linux distro (my personal choice is Fedora)
2. Install Nix (my installer of choice is [nix-installer][nix-installer]).
3. Clone this repo somewhere on the machine
4. `nix run .#home-manager -- switch --flake .#tudor`

## Considerations for WSL

### Dependencies

The WSL setup assumes that you have 1Password and npiperelay [npiperelay] installed.

[npiperelay]: https://github.com/jstarks/npiperelay

You can install npiperelay with winget:

```powershell
winget install npiperelay
```

### Installing the thing

Assuming you have Nix set up on some other machine, clone this repo and run:

```bash
nix build .#nixosConfigurations.wsl2.config.system.build.installer
```

This will build the distro tarball in `./result/tarball/`. You can then import it in WSL:

```powershell
# Create the directory that will store the distro's disk image
New-Item -ItemType Directory c:\WSL\NixOS
# Import the tarball as a distro in WSL
wsl --import NixOS c:\WSL\NixOS .\result\tarball\<whatever>.tar.gz
# Boot it!
wsl -d NixOS
```

## Considerations for encrypting secrets

Secrets are encrypted and used through [agenix][agenix]. When provisioning a new machine, make sure to
take its host public key and rekey secrets accordingly.

[nix-installer]: https://github.com/DeterminateSystems/nix-installer
[agenix]: https://github.com/ryantm/agenix/