DOTFILES = bash bin fonts git pulse python tmux vim
BASE_IMAGE = centos:7
DEV_IMAGE = devbase

.PHONY: all clean pkgs conf unconf image

all: pkgs conf

clean:
	rm -f .dockerfile

pkgs:
	sudo dnf install -y vim git stow python-pip tmux ctags colordiff tig \
			    libguestfs-tools-c virt-install weechat \
			    libvirt-daemon-config-network docker docker-compose
	sudo pip install flake8 pudb
	git clone https://github.com/gmarik/Vundle.vim.git \
		  ${HOME}/.vim/bundle/Vundle.vim
	vim -u vim/.vundle +PluginInstall +qall

conf:
	@[ -f ~/.bashrc ] && mv ~/.bashrc{,.orig} || true
	stow -v --no-folding $(DOTFILES)
	dconf load /org/gnome/ < gnome.conf

unconf:
	stow -Dv $(DOTFILES)
	@[ -f ~/.bashrc.orig ] && mv ~/.bashrc{.orig,} || true

.dockerfile: Dockerfile.in
	@sed "s|ARG_BASE|$(BASE_IMAGE)|" $< > $@

image: .dockerfile
	sudo docker build -t $(DEV_IMAGE) -f $< .
