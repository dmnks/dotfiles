DOTFILES = bash bin fonts git pulse python tmux vim docker

.PHONY: all pkgs conf unconf

all: pkgs backup conf

pkgs:
	sudo dnf install -y vim \
			    git \
			    stow \
			    python-pip \
			    tmux \
			    ctags \
			    tig \
			    libguestfs-tools-c \
			    virt-install \
			    virt-manager \
			    libvirt-daemon-config-network \
			    weechat \
			    docker \
			    docker-compose \
			    python3-flake8 \
			    python3-pudb \
			    task
	sudo systemctl enable docker
	sudo systemctl start docker
	git clone https://github.com/gmarik/Vundle.vim.git \
		  $(HOME)/.vim/bundle/Vundle.vim
	vim -u vim/.vundle +PluginInstall +qall

backup:
	@[ -f ~/.bashrc ] && mv ~/.bashrc{,.orig} || true

restore: unconf
	@[ -f ~/.bashrc.orig ] && mv ~/.bashrc{.orig,} || true

conf: unconf
	stow -v --no-folding $(DOTFILES)
	dconf load /org/gnome/ < gnome.conf

unconf:
	stow -Dv $(DOTFILES)
