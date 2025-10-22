# Tudor's Dotfiles

Tools of the trade:

* [chezmoi](https://www.chezmoi.io)
* [mise](https://mise.jdx.dev)
* [homebrew](https://brew.sh)

OS of choice: [openSUSE Tumbleweed](https://www.opensuse.org/#Tumbleweed)

## This repo's history

My dotfiles have gone through different eras. We are currently in
the era of minimalism, where my dotfiles are just a couple
config files for some tools I use daily.

Past milestones:

+ [`c520c2e`][c520c2e]: The beginning of the current era
  and the end of the Nix era.
  By this time, this repo also contained the NixOS system
  configurations of my home server (and its workloads) and of my
  WSL2 environment, running on a Windows 11 dual boot.
  Care was taken for the configs to work in 3 different settings:
  NixOS bare metal, NixOS WSL2, and Nix on "normal" Linux.
+ [`ff8a839`][ff8a839]: The beginning of the Nix era.
  It started with adopting [home-manager](https://github.com/nix-community/home-manager).
+ [`407442b`][407442b]: The return to a simple graphical environment. From the beginning of this repo's history
  up until this point I had been slowly putting together
  a kind of a desktop environment made from small components
  glued together with shell scripts. My environment included a
  theming system built with templates, with integrations for multiple applications.
  To support this heavily customised environment, I went as far
  as writing my own window manager, which attracted many more
  users and contributors: [Window Chef][wchf].

[c520c2e]: https://github.com/tudurom/dotfiles/tree/c520c2e843954ebc4e38baf4bfd0d6ea3806e4a7
[ff8a839]: https://github.com/tudurom/dotfiles/tree/ff8a8390b4c1934578dbee14874dfab26a4798cb
[407442b]: https://github.com/tudurom/dotfiles/tree/407442b21a918759c2669ca3c3672ebba2184e72
[wchf]: https://github.com/tudurom/windowchef

## Installing

1. Install Chezmoi
2. `chezmoi init <repo_url>`
3. `chezmoi apply`. This will also take care of installing brew and mise.
