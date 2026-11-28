PACKAGES := $(shell cd pkgs && ls)
NVIMPACK = ~/.local/share/nvim/site/pack/plugins/start

.PHONY: all software install uninstall plugins

all: software install plugins

software:
	sudo dnf install -y \
		 blackbox-terminal \
		 ctags \
		 dejavu-sans-mono-fonts \
		 foot \
		 fuzzel \
		 fzf \
		 gh \
		 git \
		 gnome-tweaks \
		 kanshi \
		 labwc \
		 labwc-session \
		 mako \
		 neovim \
		 podman \
		 scdoc \
		 stow \
		 swaybg \
		 swaylock \
		 tig \
		 toolbox \
		 waybar \
		 wlr-randr \
		 wlsunset \
		 xfce-polkit \
		 yq

install:
	stow -R $(PACKAGES)
	update-desktop-database ~/.local/share/applications/
	systemctl --user daemon-reload
	systemctl --user enable gcr-ssh-agent.socket
	systemctl --user enable foot-server.service
	systemctl --user start foot-server.service

uninstall:
	stow -D $(PACKAGES)
	update-desktop-database ~/.local/share/applications/
	rm -f ~/.config/fuzzel/fuzzel.ini
	rm -f ~/.config/mako/config
	rm -f ~/.config/swaylock/config
	rm -f ~/.config/waybar/style.css
	rm -f ~/.themes/default/openbox-3
	if [ -d ~/.themes ]; then \
		rmdir ~/.themes/default; \
		rmdir ~/.themes; \
	fi
	systemctl --user daemon-reload
	systemctl --user disable gcr-ssh-agent.socket
	systemctl --user disable foot-server.service
	systemctl --user stop foot-server.service

plugins:
	mkdir -p $(NVIMPACK)
	git clone \
		https://github.com/ellisonleao/gruvbox.nvim \
		$(NVIMPACK)/gruvbox
	git clone \
		https://github.com/nvim-treesitter/nvim-treesitter.git \
		$(NVIMPACK)/nvim-treesitter
	git clone \
		https://github.com/nvim-treesitter/nvim-treesitter-context.git \
		$(NVIMPACK)/nvim-treesitter-context
