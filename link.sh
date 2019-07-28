#!/bin/sh
script_dir=$(cd $(dirname $BASH_SOURCE); pwd)

ln -sf ${script_dir}/.zshrc       ~/.zshrc
ln -sf ${script_dir}/.tmux.conf   ~/.tmux.conf
ln -sf ${script_dir}/.config/nvim ~/.config/nvim

