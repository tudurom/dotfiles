#!/bin/sh

# Symlink .scripts to bin
cd $HOME

test -h bin || ln -s .scripts bin
