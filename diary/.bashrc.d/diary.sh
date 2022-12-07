gendiary() {
    local path
    for i in $(seq 0 $1); do
        path=$(EDITOR=echo note "+$i days")
        mkdir -p $(dirname $path)
        touch $path
    done
}
