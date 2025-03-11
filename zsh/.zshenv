# uv
local DOTFILES=$(dirname $PWD)

export PATH="${HOME}/.local/bin:${DOTFILES}/git:$PATH"
. "$HOME/.cargo/env"
. "$(go env GOPATH)/bin"
