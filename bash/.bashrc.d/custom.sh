source /usr/share/git-core/contrib/completion/git-prompt.sh
source /usr/share/fzf/shell/key-bindings.bash

bind '"\C-o":"mc -d\C-m"'

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWSTASHSTATE=1

export EDITOR=vim
export FZF_DEFAULT_OPTS=--layout=reverse

setup_ps1() {
    local red=$(tput setaf 9)
    local green=$(tput setaf 10)
    local yellow=$(tput setaf 11)
    local blue=$(tput setaf 12)
    local purple=$(tput setaf 13)
    local cyan=$(tput setaf 14)
    local off=$(tput sgr0)
    dollar() {
        [ $? -eq 0 ] || tput setaf 9
    }
    PS1="${green}[\u@\h \W]\$(__git_ps1 \"${purple}(%s)\")"
    PS1+="\$(dollar)\$ ${off}"
    export PS1
}

clean_containers() {
    local bin=$1
    local conts=$($bin ps -qa --filter=status=exited --no-trunc)
    local images=$($bin images -q --filter=dangling=true --no-trunc \
                 2>/dev/null)
    [ -n "$conts" ] && $bin rm -f $conts
    [ -n "$images" ] && $bin rmi -f $images || true
}

mangrep() {
    man -K -w $1 | xargs basename -a -s .gz
}

setup_ps1

alias gdiff='git diff --no-index --'
alias docker-clean='clean_containers "sudo docker"'
alias podman-clean='clean_containers podman'
