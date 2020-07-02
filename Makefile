PLUGINS = ~/.vim/pack/git/start

.PHONY: all pkgs plugins conf swm restore

all: pkgs plugins conf

pkgs:
	sudo dnf install -y vim \
	                    ctags \
	                    docker \
	                    fzf \
	                    git \
	                    ipython3 \
	                    libguestfs-tools-c \
	                    libvirt-daemon-config-network \
	                    mc \
	                    pass \
	                    podman \
	                    powerline-fonts \
	                    python3-flake8 \
	                    python3-pudb \
	                    ranger \
	                    stow \
	                    tig \
	                    tmux \
	                    virt-install \
	                    virt-manager \
	                    weechat \
	                    xterm

plugins:
	mkdir -p $(PLUGINS)
	git clone https://github.com/morhetz/gruvbox $(PLUGINS)/gruvbox
	git clone https://github.com/tpope/vim-commentary $(PLUGINS)/commentary
	git clone https://github.com/vimwiki/vimwiki $(PLUGINS)/vimwiki
	git clone https://github.com/cyberkov/openhab-vim $(PLUGINS)/openhab

conf:
	[[ -f ~/.bashrc && ! -L ~/.bashrc ]] && mv ~/.bashrc{,.orig} || true
	stow -Rv --no-folding default swm
	dconf load /org/gnome/ < gnome.conf
