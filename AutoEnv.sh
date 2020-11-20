#!/bin/bash
# File              : AutoEnv.sh
# Author            : Yunkai Li <ykli@aibee.cn>
# Date              : 25.03.2019
# Last Modified Date: 20.11.2020
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
    brew install zsh
  } || {
    echo -e "${RED}No Brew Install${WHITE}"
    exit 0
  }
fi

# If Linux, CentOS and Ubuntu check
if [ ${isLinux} = 1 ]; then
  if [ -x "$(command -v apt-get)" ]; then
    echo "Linux Ubuntu"
    linux_install="sudo -HE apt-get install"
  elif [ -x "$(command -v yum)" ]; then
    echo "Linux CentOS"
    linux_install="sudo -HE yum install"
  else
    echo "Support CentOS and Ubuntu"
    exit
  fi
fi

echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list

apt-get update && apt-get install -y apt-transport-https

apt-get install -y --no-install-recommends \
    apt-utils \
    pkg-config \
    build-essential \
    locales \
    ca-certificates

apt-get install -y --no-install-recommends \
    gcc \
    python3 \
    python3-pip \
    python3-dev \
    python3-setuptools

apt-get install -y --no-install-recommends \
    curl \
    wget \
    make \
    automake \
    cmake \
    net-tools

apt-get install -y --no-install-recommends \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libevent-dev \
    libncurses5-dev \
    cmake-curses-gui \
    libssl-dev

apt-get install -y --no-install-recommends \
    ssh \
    axel \
    silversearcher-ag \
    jq \
    gawk \
    ctags \
    id-utils \
    cscope \
    graphviz \
    tree \
    tig \

pip3 install -U pip
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# oh-my-zsh 
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
# spaceship prompt
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# .tmux
if [ ! -d "${origin}/.tmux" ]; then
  cd ${origin}
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
  cp "${abpath}/.tmux.conf.local" ${origin}
fi

echo "run following instructions when log into a server"
echo -e "${YELLOW}eval \`ssh-agent -s\`"
echo -e "ssh-add .ssh/id_rsa${WHITE}"

# awesome terminal fonts install
if [ ! -d "awesome-terminal-fonts" ]; then
  git clone https://github.com/gabrielelana/awesome-terminal-fonts
  cd "awesome-terminal-fonts"
  git checkout pathcing-strategy
  ./droid.sh
fi

# exvim
if [ ! -d ".exvim" ]; then
  echo -e "${GREEN}exvim[1/4] cloning repo${WHITE}"
  git clone https://github.com/yunkaili/main .exvim
fi

cd "${origin}/.exvim"

echo -e "${GREEN}exvim[2/4] build vimrc${WHITE}"
echo "let g:exvim_custom_path='~/.exvim/'
source ~/.exvim/.vimrc" > ~/.vimrc

echo -e "${GREEN}exvim[3/4] install vundle${WHITE}"
bash install.sh

echo -e "${GREEN}exvim[4/4] update plugins${WHITE}"
vim +PlugInstall +qall
echo -e "${RED}exvim Installed${WHITE}"
