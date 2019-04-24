PLUGINS = ~/.vim/pack/git/start

.PHONY: all pkgs plugins conf swm restore

all: pkgs plugins conf

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
			    docker \
	                    podman \
	                    python3-flake8 \
	                    python3-pudb \
	                    ipython3 \
	                    fzf \
	                    powerline-fonts \
			    ranger \
			    xterm
	sudo systemctl enable docker
	sudo systemctl start docker

plugins:
	mkdir -p $(PLUGINS)
	git clone https://github.com/morhetz/gruvbox $(PLUGINS)/gruvbox
	git clone https://github.com/w0rp/ale.git $(PLUGINS)/ale
	git clone https://github.com/tpope/vim-commentary $(PLUGINS)/commentary
	git clone https://github.com/vimwiki/vimwiki $(PLUGINS)/vimwiki

conf:
	@[ -f ~/.bashrc ] && mv ~/.bashrc{,.orig} || true
	stow -v --no-folding default
	dconf load /org/gnome/ < gnome.conf

swm:
	stow -v --no-folding --ignore=Dockerfile swm

restore:
	stow -Dv default swm || true
	@[ -f ~/.bashrc.orig ] && mv ~/.bashrc{.orig,} || true
