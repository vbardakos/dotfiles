# ZINIT Package Manager location
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
export STARSHIP_CONFIG="${ZDOTDIR}/starship.toml"
export NVIM_APPNAME=nvim.dotfiles  # avoid collisions w/ potential hard links


# If not exist, download zinit & install packages
# else just source in .zshrc
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# source ${ZDOTDIR}/install_package.zsh
# install_package "zoxide"
