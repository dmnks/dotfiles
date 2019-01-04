DOTFILES = bash bin fonts git pulse python tmux vim
PLUGINS = ~/.vim/pack/git/start

.PHONY: all pkgs plugins conf workspace restore

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
			    podman \
			    python3-flake8 \
			    python3-pudb \
			    ipython3 \
			    fzf \
			    powerline-fonts

plugins:
	mkdir -p $(PLUGINS)
	git clone https://github.com/dracula/vim $(PLUGINS)/dracula
	git clone https://github.com/w0rp/ale.git $(PLUGINS)/ale
	git clone https://github.com/tpope/vim-commentary $(PLUGINS)/commentary
	git clone https://github.com/airblade/vim-gitgutter $(PLUGINS)/gitgutter
	git clone https://github.com/itchyny/lightline.vim $(PLUGINS)/lightline
	git clone https://github.com/itchyny/vim-gitbranch $(PLUGINS)/gitbranch

conf:
	@[ -f ~/.bashrc ] && mv ~/.bashrc{,.orig} || true
	stow -v --no-folding $(DOTFILES)
	dconf load /org/gnome/ < gnome.conf

workspace:
	podman build -t dnf-workspace workspace/
	stow -v --no-folding --ignore=Dockerfile workspace

restore:
	stow -Dv $(DOTFILES) workspace || true
	@[ -f ~/.bashrc.orig ] && mv ~/.bashrc{.orig,} || true
