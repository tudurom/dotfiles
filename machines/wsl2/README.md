# NixOS on WSL2

This mostly builds on [Trundle/NixOS-WSL](https://github.com/Trundle/NixOS-WSL), with some additional changes
(read: hacks) to allow the VSCode Remote WSL extension to work:

* Pass the `VSCODE_WSL_EXT_LOCATION` environment variable forward to the program that is to be executed.
	See the last line of `syschemd.sh`, the one that calls `machinectl`.

* Run the command using a login shell, to allow `/etc/profile` to be loaded.
