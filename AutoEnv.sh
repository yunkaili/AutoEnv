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
if isOSX; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# axel
# unix
# sudo -HE apt-get install axel
# osx
# brew install axel
# from source
#

# silversearcher-ag
# unix
# sudo -HE apt-get install silversearcher-ag
# osx
# brew install the_silver_searcher
# from source
# axel -a https://geoff.greer.fm/ag/releases/the_silver_searcher-2.2.0.tar.gz

# gawk
# unix
# sudo -HE apt-get install gawk
# osx
# brew install gawk
# from source
# axel -a http://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz

# id-utils

# ctags
# sudo -HE apt-get install ctags

# scope
# wget https://downloads.sourceforge.net/project/cscope/cscope/v15.9/cscope-15.9.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fcscope%2Ffiles%2Fcscope%2Fv15.9%2F&ts=1548830338&use_mirror=jaist

# zsh
cd ${ORIGIN_PWD}

# YouCompleteMe


