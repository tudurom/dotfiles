Ansible roles and playbooks
===========================

While I very much love Nix and NixOS, I think NixOS is not suitable
for a (developer's) day-to-day-use machine.
On my personal machine, which is now just a laptop, I want to be able
to quickly change settings and run random scripts and programs, without
adapting them first, whereas on a server and/or a VM
(either a server VM, or just some tiny one for development and testing)
I prefer having the rigurousness that NixOS provides.
For this reason, I prefer running Nix with Home Manager on top of Fedora
on my laptop. I actually use [Fedora Silverblue][fedora-silverblue], which also gives me
a very nice system base that I can version and roll-back if needed, with the advantage
of looking very much like a "normal" Linux distro. I even have automatic updates
that are applied transparently on next reboot!

[fedora-silverblue]: https://fedoraproject.org/silverblue/

I would, however, like to also manage the underlying OS in a declarative way.
To do this, I am using Ansible.

The playbooks in this directory are currently meants to be run on the managed host
directly.

> [!NOTE]
> I am currently using the [local connection plugin][ansible-local].
> Many of the tasks I have now need to run with elevated priviledges (`become: true`).
> I don't want to use the usual SSH connection plugin because I don't want to run
> a local SSH server. To make sure that elevating works correctly, create a sudo
> session by running `sudo -v`.

[ansible-local]: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/local_connection.html#ansible-collections-ansible-builtin-local-connection

To run the things:

```sh
sudo -v
ansible-playbook playbooks/setup_laptop.yml
```

To lint:

```sh
ansible-lint
# or
nix flake check # this builds EVERYTHING, it will take a while
```
