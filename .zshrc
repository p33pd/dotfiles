
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Install mordern cli tools
zinit wait"1" lucid from"gh-r" as"program" for \
  sbin"**/fd" @sharkdp/fd \
  sbin"**/xh" ducaale/xh \
  sbin"**/fzf" junegunn/fzf \
  sbin"**/tspin" bensadeh/tailspin \
  sbin"**/zoxide" @ajeetdsouza/zoxide \
  sbin"**/dust" @bootandy/dust \
  sbin"**/duf" @muesli/duf \
  sbin"**/difft" Wilfred/difftastic \
  sbin"**/lazydocker" @jesseduffield/lazydocker \
  sbin"**/dive" @wagoodman/dive \
  sbin"**/btop" @aristocratos/btop

zinit ice as"command" from"gh-r" \
        pick"**/bat" \
        mv"bat*/autocomplete/bat.zsh -> _bat"
zinit light sharkdp/bat

zinit ice as"command" from"gh-r" \
        pick"**/eza"
zinit light eza-community/eza

zinit ice as"command" from"gh-r" \
        pick"**/rg"
zinit light BurntSushi/ripgrep

zinit ice as"command" from"gh-r" \
        pick"**/procs" \
        atclone"procs --gen-completion-out zsh > _procs"
zinit light dalance/procs

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

## Productivity
zinit light MichaelAquilina/zsh-you-should-use

# Add oh-my-zsh plugins
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose

# Load completions
zinit ice as"completion"
zinit snippet https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza

## Configure omz eza plugin
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zinit snippet OMZP::eza

# Shell integrations

## fzf
source <(fzf --zsh)

## bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

## zoxide completions
eval "$(zoxide init zsh)"

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Enable history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Setup history search
zinit load 'zsh-users/zsh-history-substring-search'
zinit ice wait atload'_history_substring_search_config'
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
HISTORY_SUBSTRING_SEARCH_PREFIXED=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Completion styling
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Aliases
alias myip="curl https://myip.dnsomatic.com; echo"
alias lt="eza --tree --git-ignore"
alias lta="lt -a"
alias cat=bat

## flatpak Neovim wrapper
nvim() {
    if [ -z "$1" ]; then
        flatpak run io.neovim.nvim
    else
        flatpak run io.neovim.nvim "$@"
    fi
}

alias vim="nvim"
alias vi="nvim"

# Laravel Sail alias
function sail() {
    if [ -f ./vendor/bin/sail ]; then
        ./vendor/bin/sail "$@"
    else
        echo "Sail is not available. Make sure you are in a Laravel project with Sail installed."
    fi
}

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# composer
export PATH="$HOME/.config/composer/vendor/bin/:$PATH"


. "$HOME/.cargo/env"
