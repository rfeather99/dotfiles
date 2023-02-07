#!/bin/sh
script_dir=$(cd $(dirname "$0"); pwd)

ln -sf ${script_dir}/.zshrc       ~/.zshrc
ln -sf ${script_dir}/.tmux.conf   ~/.tmux.conf
mkdir -p ~/.config
ln -sf ${script_dir}/.config/nvim ~/.config
ln -sf ${script_dir}/.git_commit_template ~/.git_commit_template

