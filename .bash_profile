export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH="/usr/local/bin:$PATH"

# bash_completionの設定
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

