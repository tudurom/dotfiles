#!/usr/bin/env bash

type brew &>/dev/null || \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew install \
  chezmoi \
  helix \
  tmux \
  jq \
  ripgrep \
  direnv \
  fish
