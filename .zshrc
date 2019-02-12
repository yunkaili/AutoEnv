export TERM="xterm-256color"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/liyunkai/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME='ys'
# ZSH_THEME="powerlevel9k/powerlevel9k"

# powerlevel9k config
# POWERLEVEL9K_MODE='awesome-patched' # nerdfont-complete
# POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%{%F{249}%}\u250f"
# POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="%{%F{249}%}\u2517%{%F{default}%}❯ "
# POWERLEVEL9K_SHOW_CHANGESET="true"
# POWERLEVEL9K_CHANGESET_HASH_LENGTH="12"

# POWERLEVEL9K_VCS_CLEAN_BACKGROUND='clear'
# POWERLEVEL9K_VCS_CLEAN_FOREGROUND='119'
# POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='clear'
# POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='214'
# POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='clear'
# POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='196'

# POWERLEVEL9K_HOME_ICON=''
# POWERLEVEL9K_HOME_SUB_ICON=''
# POWERLEVEL9K_FOLDER_ICON=''
# POWERLEVEL9K_DIR_HOME_BACKGROUND="clear"
# POWERLEVEL9K_DIR_HOME_FOREGROUND="yellow"
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear"
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="yellow"
# POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear"
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="yellow"
# POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="clear"
# POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="cyan"
# POWERLEVEL9K_STATUS_OK_BACKGROUND="clear"
# POWERLEVEL9K_STATUS_OK_FOREGROUND="clear"
# POWERLEVEL9K_STATUS_ERROR_BACKGROUND="clear"
# POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
# POWERLEVEL9K_TIME_BACKGROUND="clear"
# POWERLEVEL9K_TIME_FOREGROUND="blue"
# POWERLEVEL9K_TIME_FORMAT="%D{%H:%M  \uE868  %d.%m.%y}"
# POWERLEVEL9K_STATUS_VERBOSE="true"
# POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='cyan'
# POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='clear'
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=('context' 'dir' 'vcs')
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=('status' 'time')

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
plugins=(common-aliases
         git
         last-working-dir
         rsync
         tmux
         vi-mode
         zsh-autosuggestions
)
# history

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=/home/liyunkai/local/bin:$PATH
export LD_LIBRARY_PATH=/home/liyunkai/local/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=/home/liyunkai/local/include:$C_INCLUDE_PATH
export C_INCLUDE_PATH=/home/liyunkai/local/include/ncurses:$C_INCLUDE_PATH
export PKG_CONFIG_PATH=/home/liyunkai/local/lib/pkgconfig:$PKG_CONFIG_PATH

# Pytorch
export OMP_NUM_THREADS=1

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8

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

# trash
mkdir -p ~/.trash
alias rm=trash
alias r=trash
alias rl='ls ~/.trash'
alias ur=undelfile

undelfile()
{
  mv -i  ~/.trash/$@ ./
}

trash()
{
  mv $@ ~/.trash/
}

# Update environments every time tmux restarts
if [ -n "$TMUX" ]; then
    function refresh {
        export $(tmux show-environment | grep "^SSH_AUTH_SOCK")
        export $(tmux show-environment | grep "^DISPLAY")
    }
else
    function refresh { }
fi
function preexec {
    refresh
}

