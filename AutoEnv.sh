#!/bin/bash

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
  echo "Support Mac or Linux"
  exit 0
fi

if [ "$EUID" -ne 0 ]; then
  isRoot=0
else
  isRoot=1
fi

echo "System Check Pass"

# Auto env script
cd ~
export ORIGIN_PWD=`pwd`

# exvim
if [ ! -d ".exvim" ]; then
  echo "exvim[1/4] cloning repo"
  git clone https://github.com/yunkaili/main .exvim
  cd .exvim

  echo "exvim[2/4] build vimrc"
  echo "let g:exvim_custom_path='~/.exvim/'
  source ~/.exvim/.vimrc" > ~/.vimrc

  echo "exvim[3/4] install vundle"
  bash unix/install.sh

  echo "exvim[4/4] update plugins"
  vim +PluginInstall +PluginUpdate +qall
else
  echo "exvim Installed"
fi

# brew
if [ ${isOSX} = 1 ] && [ ! hash brew 2>/dev/null ]; then
  echo "Install Brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "No Brew Install"
fi

# System
# axel - download tools
# silversearcher-ag - better than grep
# jq - json viewer

# exvim
# gawk, ctags, cscope, idutils, sed
if [ ${isLinux} = 1 ]; then
  if [ ${isRoot} = 1 ]; then
    sudo -HE apt-get install axel silversearcher-ag jq

    sudo -HE apt-get install gawk ctags idutils cscope
  else
    echo "install from source"
    source_path="/home/liyunkai/local/source"
    install_path="/home/liyunkai/local"
    echo "download source in "${source_path}
    if [ ! -d ${source_path} ]; then
      mkdir -p ${source_path}
    fi
    
    if [ ! -d ${source_path} ]; then
      echo "${source_path} does not exist"
      exit 1
    fi

    wget https://github.com/axel-download-accelerator/axel/releases/download/v2.16.1/axel-2.16.1.tar.gz -O ${source_path}/axel.tar.gz
    wget https://geoff.greer.fm/ag/releases/the_silver_searcher-2.2.0.tar.gz -O ${source_path}/ag.tar.gz
    wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz -O ${source_path}/jq.tar.gz

    wget http://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz -O ${source_path}/gawk.tar.gz
    wget http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz -O ${source_path}/ctags.tar.gz
    wget https://downloads.sourceforge.net/project/cscope/cscope/v15.9/cscope-15.9.tar.gz -O ${source_path}/cscope.tar.gz
    wget https://downloads.sourceforge.net/project/gnuwin32/id-utils/4.0-2/id-utils-4.0-2-bin.zip -O ${source_path}/idutils.zip
    wget https://downloads.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-src.zip -O ${source_path}/sed.zip
  fi
elif [ ${isOSX} = 1 ]; then
  brew install axel the_silver_searcher jq

  brew install macvim --with-cscope --with-lua --HEAD
  brew install gawk ctags cscope idutils graphviz
fi

# zsh
cd ${ORIGIN_PWD}

# YouCompleteMe


