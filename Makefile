PACKAGES = bash desktop git podman rpm tmux utils vim wallpapers
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
		 neovim \
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
	stow --target ${HOME} -Dv --no-folding $(PACKAGES)

vim:
	curl -fLo \
	    ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

gnome:
	dconf load /org/gnome/ < gnome.conf
