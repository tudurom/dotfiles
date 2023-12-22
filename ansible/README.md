Ansible roles and playbooks
===========================

While I very much love Nix and NixOS, I think NixOS is not suitable
for a developer's day-to-day-use machine.
On my personal machine, which is now just a laptop, I want to be able
to quickly change settings and run random scripts and programs without
first adapting them, whereas on a server and/or a VM
(either a server VM, or just some tiny one for development and testing)
I do prefer having the rigurousness that NixOS provides.
For this reason, I prefer running Nix with Home Manager on top of Fedora
on my laptop. I actually use [Fedora Silverblue][fedora-silverblue], which also gives me
a very nice system base that I can version and roll-back if needed, with the advantage
of looking very much like a "normal" Linux distro. I even have automatic updates
that are applied transparently on next reboot!

[fedora-silverblue]: https://fedoraproject.org/silverblue/

I would, however, like to also manage the underlying OS in a declarative way.
I am using Ansible to achieve this.

Setup
-----

First and foremost, as a desktop user, I'd like to have some niceties like
hardware accelerated codecs and compatibility with various peripherals.
Luckily, the [Universal Blue][universal-blue] project provides
ready-made Silverblue-based OSTree images with neat additions for desktop users.

**This setup assumes that you already installed the [Universal Blue `silverblue-main`][silverblue-main] image!
Applying it on top of stock Fedora Silverblue should also work just fine!**

[universal-blue]: https://universal-blue.org/
[silverblue-main]: https://universal-blue.org/images/main/

Because I don't want to litter my Silverblue install with Ansible and Python stuff,
I am running it from a container (with either [Toolbx][toolbx] or [Distrobox][distrobox]).
To make that work, I enabled the SSH daemon, added my own SSH key to `authorized_keys`,
and configured the daemon to only allow pubkey authentication.

[toolbx]: https://containertoolbx.org/
[distrobox]: https://distrobox.it/

To prepare the environment:

```sh
distrobox create ansible-box [--image whatever]
distrobox enter ansible-box
```

TODO: setup l10n properly. This is currently done at OS install time.
I have very funny l10n choices:
* Language: British English
* Measurements, time, date etc: Dutch (Netherlands)
* Keyboard: "Romanian", XKB `ro`, on Windows it's called "Romanian (Programmers)".
  It's IMO the best if you write primarily English but you also want to be able
  to write accents and funny symbols, it has a nice selection of deadkeys that are
  not annoying to use either (looking at you, Windows "English (International)").

Running
-------

```sh
distrobox enter ansible-box
ansible-playbook playbooks/a_playbook.yml -K # the -K is short for --ask-become-pass

# or even shorter
distrobox enter ansible-box -- ansible-playbook playbooks/a_playbook.yml -K
```

To lint, run `ansible-lint` (installation left as an exercise to the reader), or:

```sh
nix flake check # this builds EVERYTHING, it will take a while
```
