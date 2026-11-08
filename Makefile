PACKAGES := $(shell cd pkgs && ls)
NVIMPACK = ~/.local/share/nvim/site/pack/plugins/start

.PHONY: all software install uninstall plugins gnome

all: software install plugins

software:
	sudo dnf install -y \
		 ctags \
		 fzf \
		 gh \
		 git \
		 gnome-shell-extension-just-perfection \
		 gnome-tweaks \
		 neovim \
		 podman \
		 scdoc \
		 stow \
		 tig \
		 toolbox \
		 yq

install:
	stow -R $(PACKAGES)
	update-desktop-database ~/.local/share/applications/

uninstall:
	stow -D $(PACKAGES)

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

gnome:
	dconf load /org/gnome/ < gnome.conf
