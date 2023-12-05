#!/bin/bash
# File              : AutoEnv.sh
# Author            : Yunkai Li <yunkai.li@hotmail.com>
# Date              : 25.03.2019
# Last Modified Date: 18.06.2022
# Last Modified By  : Yunkai Li <yunkai.li@hotmail.com>

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'

# absolute path of AutoEnv.sh
abpath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Install in the home directory in default
# replace the default path if needed
origin=$HOME

# Check System
case "$(uname -s)" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ ${machine} = "Mac" ]; then
  isOSX=1
  isLinux=0
elif [ ${machine} = "Linux" ]; then
  isOSX=0
  isLinux=1
else
  echo -e "${RED}Support Mac or Linux"
  exit 0
fi

echo -e "${GREEN}System Check Pass${WHITE}"

# Auto env script
cd ${origin}

# If Mac, brew check
if [ ${isOSX} = 1 ] && [ ! hash brew 2>/dev/null ]; then
  {
    echo -e "${GREEN}Install Brew${WHITE}"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  }
fi

if [ ${isLinux} = 1 ]; then 

  if [ ! -d "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"	
  fi
	
  if [ ! hash brew 2>/dev/null ]; then
  {
    echo -e "${GREEN}Install Brew${WHITE}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  }
  fi

fi

# Software installation
brew install axel the_silver_searcher jq
brew install gawk ctags cscope idutils graphviz tree tig
brew install vim neovim htop tmux ffmpeg wget curl fzf
locale-gen en_US.UTF-8

# ZSH Installation
cd ${origin}

if [ ! -d "${origin}/.oh-my-zsh" ]; then
  # you may reinstall zsh
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
  # copy defalut zsh config
  cp -f "${abpath}/.zshrc" ${origin}
  # change default shell to zsh
  if [ ${isRoot} = 1 ]; then
    sudo usermod -s /bin/zsh $(whoami)
  else
    chsh -s /bin/zsh
  fi
  echo -e "${RED}To make default shell zsh, You need to re-login"
  echo -e "sudo usermod -s /bin/zsh \$\(whoami\)"
  echo -e "chsh -s /bin/zsh${WHITE}"
else
  echo -e "${RED}.oh-my-zsh is found in ${origin}${WHITE}"
fi

# oh-my-zsh plugins
# spaceship prompt
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then 
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi
# conda-zsh-completion
git clone https://github.com/conda-incubator/conda-zsh-completion.git "$ZSH_CUSTOM/plugins/conda-zsh-completion"

# .tmux
if [ ! -d "${origin}/.tmux" ]; then
  cd ${origin}
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
  cp "${abpath}/.tmux.conf.local" ${origin}
  cd ${origin}
fi

echo "run following instructions when log into a server"
echo -e "${YELLOW}eval \`ssh-agent -s\`"
echo -e "ssh-add .ssh/id_rsa${WHITE}"

# awesome terminal fonts install
if [ ! -d "awesome-terminal-fonts" ]; then
  cd ${origin}
  git clone https://github.com/gabrielelana/awesome-terminal-fonts
  cd "awesome-terminal-fonts"
  git checkout pathcing-strategy
  ./droid.sh
  cd ${origin}
fi

# AstroNvim
if [ ! -d "{origin}/.config/nvim" ]; then
  cd ${origin}
  echo -e "${GREEN}astrioNvim${WHITE}"
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim "${origin}/.config/nvim"
  git clone --depth 1 https://github.com/yunkaili/astronvim_user.git "${origin}/.config/nvim/lua/user"
  cd ${origin}
fi

nvim --headless -c 'quitall'
