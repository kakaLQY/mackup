# Locale for Emacs
set -x LC_ALL en_US.UTF-8

# FZF
set -x FZF_DEFAULT_COMMAND 'fd --type file --follow --hidden --exclude .git --exclude target'
set -x FZF_DEFAULT_OPTS '--ansi --preview-window "right:60%" --preview "bat --color=always --style=header,grid --line-range :300 {}"'

# Golang
set -x GO111MODULE on
set -x GOPATH $HOME/Documents/go/gopath
set -gx PATH "$GOPATH/bin" $PATH

# Python 3.7
set -gx PATH $HOME/Library/Python/3.7/bin $PATH

# Rust
set -gx PATH $HOME/.cargo/bin $PATH
set -x RUST_BACKTRACE 1

# NPM
set -x NPMGLOBAL $HOME/.npm-global
set -gx PATH "$NPMGLOBAL/bin" $PATH

# Emacs
set -gx PATH "$HOME/.emacs.d/bin" $PATH

# Hunspell
set -x DICTIONARY en_US
set -x DICPATH $HOME/spell

# Clojure
set -gx PATH "$HOME/.clojure/bin" $PATH
