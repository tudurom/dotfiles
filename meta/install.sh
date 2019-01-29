#!/bin/sh

yay -Syu --needed $(grep '*' software.md | cut -d' ' -f2)
