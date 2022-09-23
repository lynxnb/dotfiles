# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle :compinstall filename '/home/lynx/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# Custom key bindings
bindkey "^[[1;5C" emacs-forward-word
bindkey "^[[1;5D" emacs-backward-word

# oh-my-posh theme
eval "$(oh-my-posh init zsh --config ~/.poshthemes/zash.json)"

# Enable zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
