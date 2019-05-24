#!/bin/zsh
# File              : .zshrc
# Author            : Yunkai Li <ykli@aibee.cn>
# Date              : 25.03.2019
# Last Modified Date: 24.05.2019
# Last Modified By  : Yunkai Li <ykli@aibee.cn>

export TERM="xterm-256color"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/local/bin:$HOME/.local/bin/:/usr/local/bin:$PATH

# prevent ls color
alias ls="ls --color=always"
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
plugins=(colored-man-pages colorize common-aliases git last-working-dir tmux vi-mode)
# history

source $ZSH/oh-my-zsh.sh

# User configuration
export LD_LIBRARY_PATH=$HOME/local/lib:$HOME/.local/lib:/usr/lib:/usr/local/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$HOME/local/include:$C_INCLUDE_PATH
export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH

# cuda
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:/usr/local/lib64/:$LD_LIBRARY_PATH

# caffe
export PATH=$HOME/program/caffe/build/tools/:$PATH
export PYTHONPATH=$HOME/program/caffe/python/:$PYTHONPATH

# Pytorch
export OMP_NUM_THREADS=1

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias du='du -h'
alias df='df -h'
alias ag='ag --noaffinity'
alias axel='axel -a'
alias tree='tree -C'
alias ncdu='ncdu --color dark'
alias ipython='python3 -m IPython'

# trash
mkdir -p ~/.trash
alias rm=trash
alias r=trash
alias rl='ls ~/.trash'
alias ur=undelfile

undelfile()
{
  mv -i  /ssd/ykli/.trash/$@ ./
}

trash()
{
  mv $@ /ssd/ykli/.trash/
}

# Update environments every time tmux restarts
# if [ -n "$TMUX" ]; then
    # function refresh {
        # export $(tmux show-environment | grep "^SSH_AUTH_SOCK")
        # export $(tmux show-environment | grep "^DISPLAY")
    # }
# else
    # function refresh { }
# fi
# function preexec {
    # refresh
# }

