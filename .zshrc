autoload -Uz compinit
compinit -u

# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY
# historyを共有
setopt share_history
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
# 古いコマンドと同じものは無視
setopt hist_save_no_dups
# historyコマンドは履歴に登録しない
setopt hist_no_store
# 補完時にヒストリを自動的に展開
setopt hist_expand
# 履歴をインクリメンタルに追加
setopt inc_append_history
# インクリメンタルからの検索
bindkey "^R" history-incremental-search-backward

alias vim='nvim'
alias ls='ls -aG'
alias tmux='tmux -u'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

agent="$HOME/.ssh/agent"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "no ssh-agent"
fi

# promptinitを使う場合はこちらを読み込む
# 利用可能なpromptの設定を見る
# $ prompt -l
# promptを設定する
# $ prompt [prompt名]
autoload -U promptinit
promptinit
# promptを独自で変更
PROMPT='%m:%F{green}%c%f %n%# '

# FZF settings
export FZF_DEFAULT_OPTS='--reverse --border'
function select-history() {
  BUFFER=$(history -n -r 1 | fzf +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N select-history
bindkey '^R' select-history

## fzf + docker tools
function docker-attach-active-container() {
  local container=$(docker ps --format '{{.Names}}' | fzf +m --query "$1" --select-1 --exit-0 --prompt='Containers > ')
  if [[ -n $container ]]; then
    print -z "docker attach $container"
  else
    echo 'No container selected'
  fi
}
alias doa=docker-attach-active-container

function docker-exec-active-container() {
  local container=$(docker ps --format '{{.Names}}' | fzf +m --query "$1" --select-1 --exit-0 --prompt='Containers > ')
  if [[ -n $container ]]; then
    print -z "docker exec -it $container bash"
  else
    echo 'No container selected'
  fi
}
alias doe=docker-exec-active-container

function docker-volume-rm() {
  local volumes=$(docker volume ls -q | fzf +m --query "$1" --multi --exit-0 --prompt='Volumes > ' | tr '\n' ' ')
  if [[ -n $volumes ]]; then
    print -z "docker volume rm $volumes"
  else
    echo 'No volume selected'
  fi
}
alias dov=docker-volume-rm

function docker-logs-active-container() {
  local container=$(docker ps -a --format '{{.Names}}' | fzf +m --query "$1" --select-1 --exit-0 --prompt='Containers > ')
  if [[ -n $container ]]; then
    print -z "docker logs $container -f --tail=100"
  else
    echo 'No container selected'
  fi
}
alias dol=docker-logs-active-container

function docker-debug-active-container() {
  local container=$(docker ps --format '{{.Names}}' | fzf +m --query "$1" --select-1 --exit-0 --prompt='Containers > ')
  if [[ -n $container ]]; then
    print -z "docker debug $container"
  else
    echo 'No container selected'
  fi
}
alias dod=docker-debug-active-container

# initialize pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# initialize fnm
eval "$(fnm env --use-on-cd)"

# initialize rbenv
eval "$(rbenv init - zsh)"
