#!/bin/bash

# Check System
case "$(uname -s)" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# isOSX
function isOSX() {
  if [ ${machine} = 'Mac' ]; then
    return 0
  else
    return 1
  fi
}

# isLinux
function isLinux() {
  if [ ${machine} = 'Mac' ]; then
    return 0
  else
    return 1
  fi
}

if ( ! isOSX ) && ( ! isLinux ); then
  echo "Support Mac or Linux"
  exit 0
fi

echo "System Check Pass"

function isRoot() {
  if [ "$EUID" -ne 0 ]; then
    return 1
  else
    return 0
fi
}

# if isRoot; then
  # echo "root"
# else
  # echo "no root"
# fi

# exit 0


# auto env script
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
fi

# brew
if isOSX && ! hash brew 2>/dev/null; then
  echo "Install Brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# System
# axel - download tools
# silversearcher-ag - better than grep
# jq - json viewer

# exvim
# gawk, ctags, cscope, idutils, sed
if isLinux; then
  if isRoot; then
    sudo -HE apt-get install axel silversearcher-ag jq

    sudo -HE apt-get install gawk ctags idutils cscope
  else
    source_path="/home/liyunkai/local/source"
    echo "install from source"
    echo "download source in "${source_path}
    if [ -d ${source_path} ]; then
      mkdir ${source_path}
    fi

    wget https://github.com/axel-download-accelerator/axel/releases/download/v2.16.1/axel-2.16.1.tar.gz -o ${source_path}/axel.tar.gz
    wget https://geoff.greer.fm/ag/releases/the_silver_searcher-2.2.0.tar.gz -o ${source_path}/ag.tar.gz
    wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz -o ${source_path}/jq.tar.gz


    wget http://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz -o ${source_path}/gawk.tar.gz
    wget http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz -o ${source_path}/ctags.tar.gz
    wget https://downloads.sourceforge.net/project/cscope/cscope/v15.9/cscope-15.9.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fcscope%2Ffiles%2Fcscope%2Fv15.9%2F&ts=1548846850&use_mirror=jaist -o ${source_path}/cscope.tar.gz
    wget https://downloads.sourceforge.net/project/gnuwin32/id-utils/4.0-2/id-utils-4.0-2-bin.zip?r=http%3A%2F%2Fgnuwin32.sourceforge.net%2Fpackages%2Fid-utils.htm&ts=1548847179&use_mirror=excellmedia -o ${source_path}/idutils.zip
    wget https://downloads.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-src.zip?r=http%3A%2F%2Fgnuwin32.sourceforge.net%2Fpackages%2Fsed.htm&ts=1548847171&use_mirror=jaist -o ${source_path}/sed.zip

  fi
elif isOSX; then
  brew install axel the_silver_searcher jq

  brew install macvim --with-cscope --with-lua --HEAD
  brew install gawk ctags cscope idutils graphviz
fi

# zsh
cd ${ORIGIN_PWD}

# YouCompleteMe


