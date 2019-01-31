#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'

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

if [ "$EUID" -ne 0 ]; then
  isRoot=0
else
  isRoot=1
fi

echo -e "${GREEN}System Check Pass"

# Auto env script
cd ~
export ORIGIN_PWD=`pwd`

# exvim
# TODO: debug
if [ -d ".exvim" ]; then
  echo -e "${GREEN}exvim[1/4] cloning repo${WHITE}"
  git clone https://github.com/yunkaili/main .exvim
  cd .exvim

  echo -e "${GREEN}exvim[2/4] build vimrc${WHITE}"
  echo "let g:exvim_custom_path='~/.exvim/'
  source ~/.exvim/.vimrc" > ~/.vimrc

  echo -e "${GREEN}exvim[3/4] install vundle${WHITE}"
  bash unix/install.sh

  echo -e "${GREEN}exvim[4/4] update plugins${WHITE}"
  vim +PluginInstall +PluginUpdate +qall
else
  echo -e "${RED}exvim Installed${WHITE}"
fi

# brew
if [ ${isOSX} = 1 ] && [ ! hash brew 2>/dev/null ]; then
  echo -e "${GREEN}Install Brew${WHITE}"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo -e "${RED}No Brew Install${WHITE}"
fi

# System
# axel - download tools
# silversearcher-ag - better than grep
# jq - json viewer
# TODO: add tree
# tree - directory struct viewer
# tig - git tree

# exvim
# gawk, ctags, cscope, idutils, sed
if [ ${isLinux} = 1 ]; then
  if [ ${isRoot} = 1 ]; then
    sudo -HE apt-get install axel silversearcher-ag jq

    sudo -HE apt-get install gawk ctags id-utils cscope tree tig
  else
    source_path="/home/liyunkai/local/source"
    install_path="/home/liyunkai/local"
    export PATH=/home/liyunkai/local/bin:$PATH
    export LD_LIBRARY_PATH=/home/liyunkai/local/lib:$LD_LIBRARY_PATH
    export C_INCLUDE_PATH=/home/liyunkai/local/include:$C_INCLUDE_PATH
    export PKG_CONFIG_PATH=/home/liyunkai/local/lib/pkgconfig:$PKG_CONFIG_PATH

    echo -e "${YELLOW}install from source${WHITE}"
    echo -e "${YELLOW}download source in ${source_path}${WHITE}"
    if [ ! -d ${source_path} ]; then
      mkdir -p ${source_path}
    fi
    
    if [ ! -d ${source_path} ]; then
      echo -e "${RED}${source_path} does not exist${WHITE}"
      exit 1
    fi

    # axel
    if [ ! -x "$(command -v axel)" ]; then
      echo -e "${RED}Install axel${WHITE}"
      cd ${source_path}
      target="axel.tar.gz"
      if [ ! -f ${target} ]; then
        wget https://github.com/axel-download-accelerator/axel/releases/download/v2.16.1/axel-2.16.1.tar.gz -O ${target} 
      fi
      tar xf ${target} 
      cd axel-2.16.1 && ./configure --without-ssl --prefix=${install_path} && make -j && make install
    fi
    # Build-time dependencies:
    # 
    # pkg-config
    # gettext
    # autopoint
    # Optional dependencies:
    # 
    # libssl (OpenSSL, LibreSSL or compatible) -- for SSL/TLS support.
    # https://github.com/openssl/openssl/archive/OpenSSL_1_1_1a.tar.gz
    
    # ag
    if [ ! -x "$(command -v ag)" ]; then
      echo -e "${RED}Install ag${WHITE}"

      cd ${source_path}
      # dependencies
      #pkg-config --libs liblzma
      if [ $(pkg-config --exists "liblzma"; echo $?) = 1 ]; then
        if [ ! -f "xz-5.2.4.tar.gz" ]; then 
          wget https://downloads.sourceforge.net/project/lzmautils/xz-5.2.4.tar.gz
        fi
        if [ ! -d "xz-5.2.4" ]; then
          tar xf "xz-5.2.4.tar.gz"
        fi
        cd xz-5.2.4 && ./configure --prefix=${install_path} && make -j && make install
      fi
      
      cd ${source_path}
      target="ag.tar.gz"
      if [ ! -f ${target} ]; then
        wget https://geoff.greer.fm/ag/releases/the_silver_searcher-2.2.0.tar.gz -O ${target} 
      fi
      tar xf ${target} 
      cd the_silver_searcher-2.2.0 && ./configure --prefix=${install_path} && make -j && make install 
    fi
    # Install dependencies (Automake, pkg-config, PCRE, LZMA):
    # LZMA
    # https://downloads.sourceforge.net/project/lzmautils/xz-5.2.4.tar.gz
    
    # jq
    if [ ! -x "$(command -v jq)" ]; then
      echo -e "${RED}Install jq${WHITE}"
      cd ${source_path}
      target="jq.tar.gz"
      if [ ! -f ${target} ]; then
        wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz -O ${target} 
      fi
      tar xf ${target}
      cd jq-1.6 && autoreconf -i && ./configure --with-oniguruma=builtin --disable-maintainer-mode --prefix=${install_path} && make -j && make install
    fi

    # gawk
    if [ ! -x "$(command -v gawk)" ]; then
      echo -e "${RED}Install gawk${WHITE}"
      cd ${source_path}
      target="gawk.tar.gz"
      if [ ! -f ${target} ]; then
        wget http://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz -O ${target} 
      fi
      tar xf ${target}
      unset C_INCLUDE_PATH
      cd gawk-4.2.1 && ./configure --prefix=${install_path} && make -j && make install
      export C_INCLUDE_PATH=/home/liyunkai/local/include:$C_INCLUDE_PATH
    fi

    # ctags
    if [ ! -x "$(command -v ctags)" ]; then
      echo -e "${RED}Install ctags${WHITE}"
      cd ${source_path}
      target="ctags.tar.gz"
      if [ ! -f ${target} ]; then
        wget http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz -O ${target} 
      fi
      tar xf ${target}
      cd ctags-5.8 && ./configure --prefix=${install_path} && make -j && make install
    fi
    
    # cscope
    if [ ! -x "$(command -v cscope)" ]; then
      echo -e "${RED}Install cscope${WHITE}"
      if [ ! -x "$(command -v ncurses6-config)" ]; then
        cd ${source_path}
        target="ncurses.tar.gz"
        if [ ! -f ${target} ]; then
          wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.1.tar.gz -O ${target} 
        fi
        tar xf ${target}
        cd ncurses-6.1/ && ./configure --with-shared --prefix=${install_path} && make -j && make install 
      fi
      export C_INCLUDE_PATH=/home/liyunkai/local/include/ncurses:$C_INCLUDE_PATH

      cd ${source_path}
      target="cscope.tar.gz"
      if [ ! -f ${target} ]; then
        wget https://downloads.sourceforge.net/project/cscope/cscope/v15.9/cscope-15.9.tar.gz -O ${target} 
      fi
      tar xf ${target}
      cd cscope-15.9/ && ./configure --with-ncurses=${install_path} --prefix=${install_path} && make -j && make install
    fi

    # idutils
    if [ ! -x "$(command -v gid)" ]; then
      echo -e "${RED}Install idutils${WHITE}"
      cd ${source_path}
      target="idutils.tar.gz"
      if [ ! -f ${target} ]; then
        wget https://ftp.gnu.org/gnu/idutils/idutils-4.2.tar.gz -O ${target}
        # >= v4.5 has bugs
      fi
      tar xf ${target}
      cd idutils-4.2 && ./configure --prefix=${install_path} && make -j && make install 
    fi

    # sed
    if [ ! -x "$(command -v sed)" ]; then
      echo -e "${RED}Install sed${WHITE}"
      cd ${source_path}
      target="sed.tar.gz"
      if [ ! -f ${target} ]; then
        wget http://ftp.gnu.org/gnu/sed/sed-4.2.1.tar.gz -O ${target} 
      fi
      tar xf ${target}
      cd sed-4.2.1 && ./configure --prefix=${install_path} && make -j && make install
    fi

  fi
elif [ ${isOSX} = 1 ]; then
  brew install axel the_silver_searcher jq

  brew install macvim --with-cscope --with-lua --HEAD
  brew install gawk ctags cscope idutils graphviz
fi

# zsh
cd ${ORIGIN_PWD}

# YouCompleteMe


