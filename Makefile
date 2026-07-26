PACKAGES = bash desktop git podman rpm tmux utils vim
VIMPACK = ~/.vim/pack/git/start
ICONDIR = icons/hicolor/scalable/apps

.PHONY: all software install uninstall vim gnome

all: software install vim gnome icons

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
		 neovim \
		 pass \
		 pavucontrol \
		 podman \
		 stow \
		 tig \
		 toolbox \
		 vim

install: icons
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

icons:
	mkdir -p ${HOME}/.local/share/$(ICONDIR)
	ln -sf /usr/share/$(ICONDIR)/org.gnome.Terminal.svg \
	       ${HOME}/.local/share/$(ICONDIR)/Terminal.svg
	ln -sf /usr/share/$(ICONDIR)/org.gnome.Terminal.svg \
	       ${HOME}/.local/share/$(ICONDIR)/Tmux.svg
	ln -sf /usr/share/$(ICONDIR)/org.gnome.Geary.svg \
	       ${HOME}/.local/share/$(ICONDIR)/Mutt.svg
	ln -sf /usr/share/$(ICONDIR)/org.gnome.Polari.svg \
	       ${HOME}/.local/share/$(ICONDIR)/WeeChat.svg
	ln -sf /usr/share/$(ICONDIR)/org.gnome.Contacts.svg \
	       ${HOME}/.local/share/$(ICONDIR)/Plan.svg
