#!/bin/sh

yay -Syu $(grep '*' software.md | cut -d' ' -f2)
