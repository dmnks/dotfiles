note() {
    local arg=$@
    [ -z "$arg" ] && arg="today"
    dir=$HOME/diary/$(date +'%Y/Q%q/W%V' -d "$arg")
    file=$dir/$(date +'%Y-%m-%d' -d "$arg")
    mkdir -p $dir
    touch $file
    (cd $HOME/diary; $EDITOR $file)
}

gendiary() {
    for i in $(seq 0 $1); do
        EDITOR=echo note "+$i days" >/dev/null
    done
}
