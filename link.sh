#!/bin/sh
script_dir=$(cd $(dirname "$0"); pwd)

ln -sf ${script_dir}/.zshrc       ~/.zshrc
ln -sf ${script_dir}/.tmux.conf   ~/.tmux.conf
mkdir -p ~/.config
ln -sf ${script_dir}/.config/nvim ~/.config
ln -sf ${script_dir}/.config/alacritty ~/.config
ln -sf ${script_dir}/.git_commit_template ~/.git_commit_template

# これを作らないとnull-lsがlog出力できずにおちる
mkdir -p ~/.cache/nvim

VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User
rm "$VSCODE_SETTING_DIR/settings.json"
ln -s "$script_dir/.config/vscode/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
