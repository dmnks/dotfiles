DOTFILES = bash bin fonts git pulse python tmux vim docker
PLUGINS = ~/.vim/pack/git/start

.PHONY: all pkgs plugins backup restore conf unconf

all: pkgs plugins backup conf

pkgs:
	sudo dnf install -y vim \
			    git \
			    stow \
			    tmux \
			    ctags \
			    tig \
			    libguestfs-tools-c \
			    virt-install \
			    virt-manager \
			    libvirt-daemon-config-network \
			    weechat \
			    podman \
			    python3-flake8 \
			    python3-pudb \
			    ipython3 \
			    fzf

plugins:
	mkdir -p $(PLUGINS)
	git clone https://github.com/dracula/vim $(PLUGINS)/dracula
	git clone https://github.com/morhetz/gruvbox $(PLUGINS)/gruvbox
	git clone https://github.com/w0rp/ale.git $(PLUGINS)/ale
	git clone https://github.com/junegunn/fzf.vim $(PLUGINS)/fzf
	git clone https://github.com/tpope/vim-commentary $(PLUGINS)/vim-commentary
	git clone https://github.com/airblade/vim-gitgutter $(PLUGINS)/gitgutter

backup:
	@[ -f ~/.bashrc ] && mv ~/.bashrc{,.orig} || true

restore: unconf
	@[ -f ~/.bashrc.orig ] && mv ~/.bashrc{.orig,} || true

conf: unconf
	stow -v --no-folding $(DOTFILES)

unconf:
	stow -Dv $(DOTFILES)
