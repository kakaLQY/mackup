# rbenv
set -gx PATH '/Users/kaka/.rbenv/shims' $PATH
set -gx RBENV_SHELL fish
source '/usr/local/Cellar/rbenv/1.1.2/libexec/../completions/rbenv.fish'
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (rbenv "sh-$command" $argv|psub)
  case '*'
    command rbenv "$command" $argv
  end
end

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
