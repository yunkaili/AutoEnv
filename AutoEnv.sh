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
if [ ! -d ".exvim" ]; then
  echo -e "${GREEN}exvim[1/4] cloning repo${WHITE}"
  git clone https://github.com/yunkaili/main .exvim
fi

cd .exvim

echo -e "${GREEN}exvim[2/4] build vimrc${WHITE}"
echo "let g:exvim_custom_path='~/.exvim/'
source ~/.exvim/.vimrc" > ~/.vimrc

echo -e "${GREEN}exvim[3/4] install vundle${WHITE}"
#bash unix/install.sh

echo -e "${GREEN}exvim[4/4] update plugins${WHITE}"
#vim +PluginInstall +qall
echo -e "${RED}exvim Installed${WHITE}"

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
# ftp://mama.indstate.edu/linux/tree/tree-1.8.0.tgz
# tig - git tree
# https://github.com/jonas/tig/releases/download/tig-2.4.1/tig-2.4.1.tar.gz

source_path="/home/liyunkai/local/source"
install_path="/home/liyunkai/local"
export PATH=/home/liyunkai/local/bin:$PATH
export LD_LIBRARY_PATH=/home/liyunkai/local/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=/home/liyunkai/local/include:$C_INCLUDE_PATH
export PKG_CONFIG_PATH=/home/liyunkai/local/lib/pkgconfig:$PKG_CONFIG_PATH

install_w_config()
{
  local cmd target url dirname newop conf
  while [[ ${1} ]];
  do
      case "${1}" in
          -cmd)
            cmd=${2}
            shift
            ;;
          -target)
            target=${2}
            shift
            ;;
          -url)
            url=${2}
            shift
            ;;
          -dirname)
            dirname=${2}
            shift
            ;;
          -conf)
            conf="$conf ${2}"
            shift
            ;;
          -newop)
            newop=${2}
            shift
            ;;
          *) return 1 # illegal option
      esac

      if ! shift; then
        echo 'Missing parameter argument.' >&2
        return 1
      fi

  done

  if [ ! -x "$(command -v ${cmd})" ]; then
    echo -e "${RED}Install ${cmd}${WHITE}"
    cd ${source_path}
    if [ ! -f ${target} ]; then
      wget ${url} -O ${target}
    fi
    tar xf ${target}

    cd ${dirname}

    if [ -n "${newop}" ]; then
      eval ${newop}
    fi

    if [ -z ${conf} ]; then
      ./configure --prefix=${install_path}
    else
      ./configure ${conf} --prefix=${install_path}
    fi
    make -j && make install
  fi
}

if [ ${isLinux} = 1 ]; then
  if [ ${isRoot} = 1 ]; then
    sudo -HE apt-get install axel silversearcher-ag jq
    sudo -HE apt-get install gawk ctags id-utils cscope graphviz tree tig
  else
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
    install_w_config \
      -cmd axel \
      -target axel.tar.gz \
      -url https://github.com/axel-download-accelerator/axel/releases/download/v2.16.1/axel-2.16.1.tar.gz \
      -dirname axel-2.16.1 \
      -conf --without-ssl
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

    install_w_config \
      -cmd ag \
      -target ag.tar.gz \
      -url https://geoff.greer.fm/ag/releases/the_silver_searcher-2.2.0.tar.gz\
      -dirname the_silver_searcher-2.2.0
    # Install dependencies (Automake, pkg-config, PCRE, LZMA):
    # LZMA
    # https://downloads.sourceforge.net/project/lzmautils/xz-5.2.4.tar.gz

    # jq
    install_w_config \
      -cmd jq \
      -target jq.tar.gz \
      -url https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz \
      -dirname jq-1.6 \
      -newop "autoreconf -i" \
      -conf --with-oniguruma=builtin \
      -conf --disable-maintainer-mode

    # gawk
    install_w_config \
      -cmd gawk \
      -target gawk.tar.gz \
      -url http://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz \
      -dirname gawk-4.2.1 \
      -newop "unset C_INCLUDE_PATH"
    export C_INCLUDE_PATH=/home/liyunkai/local/include:$C_INCLUDE_PATH

    # ctags
    install_w_config \
      -cmd ctags \
      -target ctags.tar.gz \
      -url http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz \
      -dirname ctags-5.8

    # cscope
    # dependencies
    install_w_config \
      -cmd ncurses6-config \
      -target ncurses.tar.gz \
      -url https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.1.tar.gz \
      -dirname ncurses-6.1 \
      -conf --with-shared \
      -conf --enable-pc-files
    export C_INCLUDE_PATH=/home/liyunkai/local/include/ncurses:$C_INCLUDE_PATH

    install_w_config \
      -cmd cscope \
      -target cscope.tar.gz \
      -url https://downloads.sourceforge.net/project/cscope/cscope/v15.9/cscope-15.9.tar.gz \
      -dirname cscope-15.9 \
      -conf --with-ncurses=${install_path}

    # idutils
    # >= v4.5 has bugs
    install_w_config \
      -cmd gid \
      -target idutils.tar.gz \
      -url https://ftp.gnu.org/gnu/idutils/idutils-4.2.tar.gz \
      -dirname idutils-4.2

    # sed
    install_w_config \
      -cmd sed \
      -target sed.tar.gz \
      -url http://ftp.gnu.org/gnu/sed/sed-4.2.1.tar.gz \
      -dirname sed-4.2.1

    # tree
    # install_w_config \
      # -cmd tree \
      # -target tree.tgz \
      # -url http://mama.indstate.edu/users/ice/tree/src/tree-1.8.0.tgz \
      # -dirname tree-1.8.0

    echo -e "${REA}You may need to install ${YELLOW}tree ${RED}manually"
    echo -e "${GREEN}http://mama.indstate.edu/users/ice/tree/src/tree-1.8.0.tgz${WHITE}"

    # tig
    # install_w_config \
      # -cmd tig \
      # -target tig.tar.gz \
      # -url https://github.com/jonas/tig/releases/download/tig-2.4.1/tig-2.4.1.tar.gz \
      # -dirname tig-2.4.1
  fi
elif [ ${isOSX} = 1 ]; then
  brew install axel the_silver_searcher jq

  brew install macvim --with-cscope --with-lua --HEAD
  brew install gawk ctags cscope idutils graphviz tree tig
fi

# zsh
cd ${ORIGIN_PWD}

# you may reinstall zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# you may re-install
if [ ${isRoot} = 1 ]; then
  sudo usermod -s /bin/zsh $(whoami)
else
  echo "pass"
fi

# .tmux

# YouCompleteMe


