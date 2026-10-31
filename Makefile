PACKAGES = bash desktop git podman rpm tmux utils vim
NVIMPACK = ~/.local/share/nvim/site/pack/plugins/start

.PHONY: all software install uninstall vim gnome

all: software install neovim

software:
	sudo dnf install -y \
		 ctags \
		 fzf \
		 gh \
		 git \
		 gnome-tweaks \
		 neovim \
		 podman \
		 stow \
		 tig \
		 toolbox

install:
	stow --target ${HOME} -Rv --no-folding $(PACKAGES)

uninstall:
	stow --target ${HOME} -Dv --no-folding $(PACKAGES)

neovim:
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
