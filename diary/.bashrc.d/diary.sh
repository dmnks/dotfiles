note() {
    local arg=$@
    [ -z "$arg" ] && arg="today"
    dir=$HOME/diary/$(date +'%Y/Q%q/%m-%b/W%V' -d "$arg")
    file=$dir/$(date +'%Y-%m-%d' -d "$arg")
    mkdir -p $dir
    touch $file
    echo $file
}

gendiary() {
    for i in $(seq 0 $1); do
        note "+$i days" >/dev/null
    done
}
