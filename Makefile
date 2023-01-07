PACKAGES = bash vim git utils desktop
VIMPACK = ~/.vim/pack/git/start

.PHONY: all software install uninstall vim gnome

all: software install vim gnome

software:
	sudo dnf install -y \
		 ctags \
		 dejavu-sans-mono-fonts \
		 foot \
		 fzf \
		 git \
		 isync \
		 jetbrains-mono-nl-fonts \
		 libguestfs-tools-c \
		 libvirt-daemon-config-network \
		 mc \
		 mutt \
		 pass \
		 podman \
		 stow \
		 tig \
		 vim \
		 virt-install \
		 virt-manager \
		 weechat

install:
	stow -Rv --no-folding $(PACKAGES)

uninstall:
	stow -Dv $(PACKAGES)

vim:
	mkdir -p $(VIMPACK)
	git clone \
	    https://github.com/morhetz/gruvbox $(VIMPACK)/gruvbox
	git clone \
	    https://github.com/tpope/vim-commentary $(VIMPACK)/commentary

gnome:
	dconf load /org/gnome/ < gnome.conf
