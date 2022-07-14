source /usr/share/git-core/contrib/completion/git-prompt.sh

bind '"\C-o":"mc -d\C-m"'

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWSTASHSTATE=1

export EDITOR=vim

setup_ps1() {
    local c_red=$(tput setaf 9)
    local c_green=$(tput setaf 10)
    local c_yellow=$(tput setaf 11)
    local c_blue=$(tput setaf 12)
    local c_purple=$(tput setaf 13)
    local c_cyan=$(tput setaf 14)
    local c_off=$(tput sgr0)
    c_dollar() {
        [ $? -eq 0 ] && tput sgr0 || tput setaf 9
    }
    os_release() {
        grep "^$1=" /etc/os-release | cut -d'=' -f2 | tr -d \"
    }
    PS1="\[${c_green}\]"
    if [ "$HOSTNAME" != "thinkpad" ]; then
        PS1+="[$HOSTNAME]"
        local os=$(os_release ID)
        local version=$(os_release VERSION_ID)
        [[ -n "$os" && -n "$version" ]] && PS1+="(${os}-${version})"
    fi
    PS1+="-> \[${c_cyan}\]\W"
    PS1+="\[${c_purple}\]\$(__git_ps1 \"(%s)\")"
    PS1+="\[\$(c_dollar)\]"
    [ "$EUID" != 0 ] && PS1+="\$" || PS1+="#"
    PS1+="\[${c_off}\] "
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

plan() {
    grep '^  ' ~/plan/daily.plan | tail -n +2 | sed 's/^  //g'
}

setup_ps1

alias gdiff='git diff --no-index --'
alias docker-clean='clean_containers "sudo docker"'
alias podman-clean='clean_containers podman'
