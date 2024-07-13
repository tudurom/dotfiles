#!/usr/bin/env bash

type brew &>/dev/null || \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew install \
  mise \
  helix \
  tmux \
  jq \
  ripgrep \
  fd \
  direnv \
  fish
