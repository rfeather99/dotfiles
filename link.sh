#!/bin/sh
script_dir=$(cd $(dirname $BASH_SOURCE); pwd)

ln -sf ${script_dir}/.bash_profile ~/.bash_profile
ln -sf ${script_dir}/.zshrc ~/.zshrc
ln -sf ${script_dir}/.tmux.conf ~/.tmux.conf
ln -sf ${script_dir}/.vimrc ~/.vimrc
ln -sf ${script_dir}/.cache/dein/dein.toml ~/.cache/dein/dein.toml
ln -sf ${script_dir}/.cache/dein/dein_lazy.toml ~/.cache/dein/dein_lazy.toml

