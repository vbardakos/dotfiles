set -g fish_greeting

export EDITOR=nvim
export HOMEBREW_NO_ENV_HINTS=1
export XDG_CONFIG_HOME="$HOME/.config"

set --export TMUX_SESSION $(tmux display-message -p '#S' 2>/dev/null | sed -E 's/^[0-9]+$/unnamed/')

# note: resolves issue with envvar update after session renames
# usage: tmux sends a signal on session rename which triggers this func
function __refresh_tmux_session --on-signal USR1
    set new (tmux display-message -p '#S' 2>/dev/null | sed -E 's/^[0-9]+$/unnamed/')
    if test "$new" != "$TMUX_SESSION"
        set -gx TMUX_SESSION $new
        omp_repaint_prompt
    end
end


oh-my-posh init fish --config $XDG_CONFIG_HOME/ohmyposh/amro.omp.json | source

abbr -a conf 'cd $HOME/.config'
abbr -a pa 'source .venv/bin/activate.fish'
abbr -a pd 'deactivate'


alias tt="tmux"
alias td="tmux detach"
alias ta="tmux attach"
alias vim="nvim"
# alias conf="cd ~/.config"
alias lg="lazygit"
# alias pa="source .venv/bin/activate.fish"
# alias pd="deactivate"
alias dotfiles="git --git-dir=\$HOME/dotfiles/ --work-tree=\$HOME"

function gbrowse
    # 1. Get the remote origin URL
    set -l remote_url (git config --get remote.origin.url)

    # 2. Return if no remote is found
    if test -z "$remote_url"
        echo "Error: No remote origin found."
        return 1
    end

    # 3. Get the current branch
    set -l current_branch (git branch --show-current)

    # 4. Clean URL (convert SSH to HTTPS and remove .git)
    # Replaces git@github.com:user/repo.git with 
    set -l clean_url (echo $remote_url | sed -E 's|git@([^:]+):|https://\1/|; s|\.git$||')

    # 5. Build and open the final URL
    # Works for GitHub and GitLab
    set -l final_url "$clean_url/tree/$current_branch"

    echo "Opening: $final_url"
    open $final_url
end

if status is-interactive
# Commands to run in interactive sessions can go here
end


# neofetch
