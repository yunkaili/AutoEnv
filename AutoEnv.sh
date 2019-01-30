#!/bin/bash

# auto env script
cd ~

export ORIGIN_PWD=`pwd`

# exvim
echo "exvim[1/4] cloning repo"
if [ ! -d ".exvim" ]; then
    git clone https://github.com/yunkaili/main .exvim
fi
cd .exvim

echo "exvim[2/4] build vimrc"
#bash unix/vim.sh
echo "let g:exvim_custom_path='~/.exvim/'
source ~/.exvim/.vimrc" > ~/.vimrc

echo "exvim[3/4] install vundle"
bash unix/install.sh

echo "exvim[4/4] update plugins"
vim +PluginInstall +PluginUpdate +qall

# brew

# axel

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
