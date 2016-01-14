# DNF workspace

DNF_MAIN=$HOME/dnf
DNF_BIN=$DNF_MAIN/bin
DNF_PLUGINS=$HOME/dnf-plugins-core/plugins:$HOME/dnf-plugins-extras/plugins
DNF_ARGS="--setopt pluginpath=\"$(echo $DNF_PLUGINS | tr : ' ')\" -c $DNF_MAIN/etc/dnf/dnf.conf"

alias dnf-2="PYTHONPATH=$DNF_PLUGINS $DNF_BIN/dnf-2 $DNF_ARGS"
alias dnf-3="PYTHONPATH=$DNF_PLUGINS $DNF_BIN/dnf-3 $DNF_ARGS"
alias dnf=dnf-3
alias dnfpath="PYTHONPATH=$DNF_MAIN:$DNF_PLUGINS"
alias sudo="sudo "

dnfpath source $DNF_MAIN/etc/bash_completion.d/dnf
