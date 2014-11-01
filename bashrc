# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# Use our custom vim build
MYVIM="~/software/vim/install"
alias vim="$MYVIM/bin/vim"
alias gvim="$MYVIM/bin/gvim"
alias vimdiff="$MYVIM/bin/vimdiff"
alias gvimdiff="$MYVIM/bin/gvimdiff"
export MANPATH="$MYVIM/share/man:$(manpath)"
export GIT_EDITOR="$MYVIM/bin/gvim -f"
