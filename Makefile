PACKAGES = bash desktop git podman rpm tmux utils vim
VIMPACK = ~/.vim/pack/git/start

.PHONY: all software install uninstall vim gnome

all: software install vim gnome

software:
	sudo dnf install -y \
		 ctags \
		 dejavu-sans-mono-fonts \
		 foot \
		 fzf \
		 gh \
		 git \
		 gnome-extensions-app \
		 gnome-tweaks \
		 jetbrains-mono-nl-fonts \
		 lsd \
		 pass \
		 pavucontrol \
		 podman \
		 stow \
		 tig \
		 toolbox \
		 vim

install:
	stow --target ${HOME} -Rv --no-folding $(PACKAGES)
	update-desktop-database ~/.local/share/applications/

uninstall:
	stow --target ${HOME} -Dv $(PACKAGES)

vim:
	mkdir -p $(VIMPACK)
	git clone \
	    https://github.com/morhetz/gruvbox $(VIMPACK)/gruvbox
	git clone \
	    https://github.com/tpope/vim-commentary $(VIMPACK)/commentary

gnome:
	dconf load /org/gnome/ < gnome.conf
