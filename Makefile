PACKAGES = bash vim git tmux mc utils desktop xterm
VIMPACK = ~/.vim/pack/git/start

.PHONY: all software plugins conf

all: software plugins conf

software:
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
	mkdir -p $(VIMPACK)
	git clone \
	    https://github.com/morhetz/gruvbox $(VIMPACK)/gruvbox
	git clone \
	    https://github.com/tpope/vim-commentary $(VIMPACK)/commentary
	git clone \
	    https://github.com/vimwiki/vimwiki $(VIMPACK)/vimwiki
	git clone \
	    https://github.com/cyberkov/openhab-vim $(VIMPACK)/openhab

conf:
	[[ -f ~/.bashrc && ! -L ~/.bashrc ]] && mv ~/.bashrc{,.orig} || true
	stow -Rv --no-folding $(PACKAGES)
	dconf load /org/gnome/ < gnome.conf
	xrdb ~/.Xresources
