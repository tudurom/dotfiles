tudurom's dotfiles
==================

> you are your dotfiles

A mix of style and usability, these are my dotfiles. This repo is structured in a way first-time UNIX users and ricers can understand what's going on, with explications for each directory.

**Note: I made my dotfiles public for educational purposes. Instead of
copying entire files or directories from here, please study them first and
copy the bits you need.**

Managing
--------

I manage my dotfiles using [XStow][xstow] and the [`./deploy.sh`][deploy] script.

`./deploy.sh` makes sure that there are no conflicts and ignores `README.md`
files and some directories like `firefox` and `startpage`.

Xstow is very similar and modeled after GNU Stow. [Here's a neat article about managing your dotfiles with stow to get a better understanding on what it does][xero-stow].

[xstow]: http://xstow.sourceforge.net/
[deploy]: https://github.com/tudurom/dotfiles/blob/master/deploy.sh
[xero-stow]: http://blog.xero.nu/managing_dotfiles_with_gnu_stow

Directory structure
-------------------

Each directory contains a file structure that is going to be symlinked in
`$HOME`, and a `README.md` file with a short description about the
component.
