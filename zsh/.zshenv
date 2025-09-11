# uv
local DOTFILES=$(dirname $PWD)

export PATH="usr/local/bin:${HOME}/.local/bin:${DOTFILES}/git:$PATH"
. "$HOME/.cargo/env"
. "$(go env GOPATH)/bin"
