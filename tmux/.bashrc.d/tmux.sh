if [ -f /run/.toolboxenv ]; then
    alias tmux="tmux -L $(sh -c 'source /run/.containerenv; echo $name')"
else
    alias tmux="systemd-run --quiet --scope --user tmux"
fi
