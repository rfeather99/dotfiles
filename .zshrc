fpath+=($HOME/.docker/completions $fpath)
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
alias difit="npx difit@latest"
copilot() {
  fnm exec --using default -- copilot "$@"
}
opencode() {
  fnm exec --using default -- opencode "$@"
}

# ローカルの場合は、1passwordのssh agentを使う
if [[ -z "$SSH_CONNECTION" ]]; then
  op_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

  if [[ -S "$op_sock" ]]; then
    export SSH_AUTH_SOCK="$op_sock"
  fi
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

function docker-stop-active-container() {
  local container=$(docker ps --format '{{.Names}}' | fzf +m --query "$1" --multi --exit-0 --prompt='Containers > ' | tr '\n' ' ')
  if [[ -n $container ]]; then
    print -z "docker stop $container"
  else
    echo 'No container selected'
  fi
}
alias dos=docker-stop-active-container

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

function docker-restart-container() {
  # 起動中のコンテナリストを取得し、fzfで選択
  local container=$(docker ps -a --format '{{.Names}}' | fzf +m --query "$1" --select-1 --exit-0 --prompt='Containers > ')
  if [[ -n $container ]]; then
    print -z "docker restart $container"
  else
    echo 'No container selected'
  fi
}
alias dor=docker-restart-container

function docker-compose-down-services() {
  local containers=$(docker compose ps --services | fzf +m --query "$1" --multi --exit-0 --prompt='Services > ' | tr '\n' ' ')
  if [[ -n $containers ]]; then
    print -z "docker compose down $containers"
  else
    echo 'No container selected'
  fi
}
alias dcd=docker-compose-down-services

## docker port proxy tools

function _docker_pick_container() {
  docker ps --format '{{.Names}}' \
    | fzf +m --query "$1" --select-1 --exit-0 --prompt='Containers > '
}

function _docker_first_network() {
  docker inspect --format '{{range $k, $v := .NetworkSettings.Networks}}{{println $k}}{{end}}' "$1" \
    | head -n1
}

function _docker_parse_port_spec() {
  local spec="$1"

  if [[ -z "$spec" ]]; then
    return 1
  fi

  if [[ "$spec" == *:* ]]; then
    REPLY_HOST_PORT="${spec%%:*}"
    REPLY_CONTAINER_PORT="${spec##*:}"
  else
    REPLY_HOST_PORT="$spec"
    REPLY_CONTAINER_PORT="$spec"
  fi

  [[ "$REPLY_HOST_PORT" =~ ^[0-9]+$ && "$REPLY_CONTAINER_PORT" =~ ^[0-9]+$ ]]
}

function _docker_proxy_name() {
  echo "port-proxy-$1-$2-$3"
}

function _docker_build_proxy_cmd() {
  local container="$1"
  local host_port="$2"
  local container_port="$3"
  local network="$4"
  local proxy_name="$(_docker_proxy_name "$container" "$host_port" "$container_port")"

  echo "docker run --rm -d --name ${proxy_name} --network ${network} -p ${host_port}:${host_port} alpine/socat TCP-LISTEN:${host_port},fork,reuseaddr TCP:${container}:${container_port}"
}

function _docker_choose_container_and_ports() {
  local arg1="$1"
  local arg2="$2"
  local query=""
  local port_spec=""
  local container network

  if _docker_parse_port_spec "$arg1"; then
    port_spec="$arg1"
  else
    query="$arg1"
    port_spec="$arg2"
  fi

  container=$(_docker_pick_container "$query")
  [[ -n "$container" ]] || { echo 'No container selected'; return 1; }

  if [[ -z "$port_spec" ]]; then
    read "port_spec?Port (3000 or 3010:3000) > "
  fi

  _docker_parse_port_spec "$port_spec" || { echo "Invalid port spec: $port_spec"; return 1; }

  network=$(_docker_first_network "$container")
  [[ -n "$network" ]] || { echo "No network found for container: $container"; return 1; }

  REPLY_CONTAINER="$container"
  REPLY_NETWORK="$network"
  return 0
}

function docker-port-proxy-active-container() {
  _docker_choose_container_and_ports "$1" "$2" || return 1

  print -z "$(_docker_build_proxy_cmd "$REPLY_CONTAINER" "$REPLY_HOST_PORT" "$REPLY_CONTAINER_PORT" "$REPLY_NETWORK")"
}
alias dop=docker-port-proxy-active-container

function docker-port-proxy-recreate() {
  _docker_choose_container_and_ports "$1" "$2" || return 1

  local proxy_name="$(_docker_proxy_name "$REPLY_CONTAINER" "$REPLY_HOST_PORT" "$REPLY_CONTAINER_PORT")"
  print -z "docker rm -f ${proxy_name} >/dev/null 2>&1; $(_docker_build_proxy_cmd "$REPLY_CONTAINER" "$REPLY_HOST_PORT" "$REPLY_CONTAINER_PORT" "$REPLY_NETWORK")"
}
alias dopx=docker-port-proxy-recreate

function docker-port-proxy-list() {
  docker ps -a \
    --filter "name=^port-proxy-" \
    --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
}
alias dopl=docker-port-proxy-list

function docker-port-proxy-kill() {
  local selected

  selected=$(
    docker ps -a \
      --filter "name=^port-proxy-" \
      --format '{{.Names}}\t{{.Ports}}\t{{.Status}}' \
      | fzf -m --query "$1" --prompt='Port proxies > ' \
      | awk '{print $1}'
  )

  [[ -n "$selected" ]] || { echo 'No proxy selected'; return 1; }

  print -z "docker stop ${(j: :)${(f)selected}}"
}
alias dopk=docker-port-proxy-kill

# redis-cli
# 指定されたキー、ポート、データベースから値を取得する関数
get_redis_value() {
  local KEY=$1
  local PORT=$2
  local DB=$3

  # データベースを指定して一度のコマンドで処理する
  local KEY_TYPE=$(redis-cli -p "$PORT" -n "$DB" TYPE "$KEY" | tr -d '\r')
  # データ型に応じて値を取得する
  local VALUE
  case $KEY_TYPE in
    string)
      VALUE=$(redis-cli -n "$DB" -p $PORT GET "$KEY")
      ;;
    list)
      VALUE=$(redis-cli -n "$DB" -p $PORT LRANGE "$KEY" 0 -1)
      ;;
    set)
      VALUE=$(redis-cli -n "$DB" -p $PORT SMEMBERS "$KEY")
      ;;
    hash)
      VALUE=$(redis-cli -n "$DB" -p $PORT HGETALL "$KEY")
      ;;
    zset)
      VALUE=$(redis-cli -n "$DB" -p $PORT ZRANGE "$KEY" 0 -1 WITHSCORES | awk 'NR%2{printf "%s, ", $0; next} {print $0}')
      ;;
    *)
      echo "Unknown data type: $KEY_TYPE"
      return 1
      ;;
  esac

  # 結果を返す
  #echo "$VALUE"
  echo "$KEY_TYPE:$VALUE"
}

redis-fzf() {
  # デフォルトポート
  local REDIS_PORT="6379"

  # 引数としてポート番号が渡された場合、そのポート番号を使用
  if [ ! -z "$1" ]; then
    REDIS_PORT="$1"
  fi

  # DBをfzfで選択
  local DB=$(seq 0 15 | fzf --prompt="Select Redis DB: ")

  if [ -z "$DB" ]; then
    echo "No DB selected"
    return 1
  fi

  # キーの一覧をfzfで表示して選択
  local KEY=$(redis-cli -n $DB -p $REDIS_PORT KEYS "*" | fzf --prompt="Select a Redis key: " --preview="
    KEY_TYPE=\$(redis-cli -n $DB -p $REDIS_PORT TYPE {});
    case \$KEY_TYPE in
      string)
        redis-cli -n $DB -p $REDIS_PORT GET {}
        ;;
      list)
        redis-cli -n $DB -p $REDIS_PORT LRANGE {} 0 -1 | tr '\n' ' '
        ;;
      set)
        redis-cli -n $DB -p $REDIS_PORT SMEMBERS {} | tr '\n' ' '
        ;;
      hash)
        redis-cli -n $DB -p $REDIS_PORT HGETALL {} | tr '\n' ' '
        ;;
      zset)
        redis-cli -n $DB -p $REDIS_PORT ZRANGE {} 0 -1 WITHSCORES | awk 'NR%2==1{printf \"%s, \", \$0; next} {print \$0}'
        ;;
      *)
        echo 'Unknown data type'
        ;;
    esac
  ")
  if [ -z "$KEY" ]; then
    echo "No key selected"
    return 1
  fi

  # 選択したキーの値を取得して表示
  local result=$(get_redis_value "$KEY" "$REDIS_PORT" "$DB")
  local KEY_TYPE="${result%%:*}"  # コロンの前の部分を取得
  local VALUE="${result#*:}"  # コロンの後の部分を取得

  # 結果を表示
  echo "Key: $KEY"
  echo "Type: $KEY_TYPE"
  echo "Value:"
  echo "$VALUE"
}

# initialize fnm
fnm_cmds=(fnm node npm npx yarn)
fnm_lazy() {
  unalias "${fnm_cmds[@]}"
  eval "$(fnm env --use-on-cd)"
}
for cmd in "${fnm_cmds[@]}"; do
  alias $cmd="fnm_lazy && $cmd"
done

# initialize rbenv
export PATH="$HOME/.rbenv/shims:$PATH"
rbenv_cmds=(rbenv ruby bundle gem irb rake)
rbenv_lazy() {
  unalias "${rbenv_cmds[@]}"
  eval "$(rbenv init - zsh)"
}
for cmd in "${rbenv_cmds[@]}"; do
  alias $cmd="rbenv_lazy && $cmd"
done

# setup uv
. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion zsh)"


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
