#!/bin/bash
# File              : AutoEnv.sh
# Author            : Yunkai Li <ykli@aibee.cn>
# Date              : 25.03.2019
# Last Modified Date: 26.04.2019
# Last Modified By  : Yunkai Li <ykli@aibee.cn>

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

# Python ENV Check
if [ ! -x "$(command -v python3)" ]; then
  echo "install python3 first"
  exit
  # if [ ${isLinux} = 1 ]; then
  #   # install by root
  #   if [ -x "$(command -v apt-get)" ]; then
  #     sudo -HE apt-get install python3 python3-pip 
  #   elif [ -x "$(command -v yum)" ]; then
  #     sudo yum -HE install yum-utils
  #     sudo yum -HE install https://centos7.iuscommunity.org/ius-release.rpm
  #     sudo yum -HE install python36u python36u-devel python36u-pip
  #   else
  #     echo "Unknown System"
  #     exit
  #   fi
  # elif [ ${isOSX} = 1 ]; then
  #   brew install python3
  # fi
fi

# Software installation
install_w_config()
{
  local install_type cmd target url dirname newop conf
  newop="ls"
  while [[ ${1} ]];
  do
      case "${1}" in
          -type)
            install_type=${2}
            shift
            ;;
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
            newop="$newop && ${2}"
            shift
            ;;
          *)
            echo "illegal option"
            echo $1
            return 1 # illegal option
      esac

      if ! shift; then
        echo 'Missing parameter argument.' >&2
        return 1
      fi
  done

  # install in anyway
  echo -e "${RED}Install ${cmd}${WHITE}"
  cd ${source_path}

  if [ ${install_type} = 'tar' ]; then
    if [ -x "$(command -v ${cmd})" ]; then
      return 0
    fi
    # download tar file
    if [ -d ${dirname} ]; then
      /bin/rm ${dirname} -rf
    fi
    if [ ! -f ${target} ]; then
      wget ${url} -O ${target}
    fi
    tar xf ${target}

  elif [ ${install_type} = 'git' ]; then
    # clone from git
    if [ ! -d ${dirname} ]; then
    	git clone --recursive ${url} ${dirname}
    else
	cd ${dirname} 
	git checkout * 
	git pull origin master
        cd ..	
    fi
  else
    echo "Unknown Install Type"
    return 1
  fi

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

}

if [ ${isLinux} = 1 ]; then

  # install by root
  # if [ -x "$(command -v apt-get)" ]; then
  #   sudo -HE apt-get install axel silversearcher-ag jq
  #   sudo -HE apt-get install gawk ctags id-utils cscope graphviz tree tig
  #   sudo -HE apt-get install libevent-dev libpng libpng-dev
  #   sudo -HE apt-get install zsh
  # elif [ -x "$(command -v yum)" ]; then
  #   sudo -HE yum install axel the_silver_searcher jq
  #   sudo -HE yum install gawk ctags id-utils cscope graphviz tree tig
  #   sudo -HE yum install libevent-devl libpng libpng-devel
  #   sudo -HE yum install zsh
  # else
  #   echo "Unknown System"
  #   exit
  # fi

  # install from source
  source_path=${origin}/local/source
  install_path=${origin}/local
  unset LD_LIBRARY_PATH C_INCLUDE_PATH PKG_CONFIG_PATH
  export PATH=${origin}/local/bin:$PATH
  export LD_LIBRARY_PATH=${origin}/local/lib:$LD_LIBRARY_PATH
  export C_INCLUDE_PATH=${origin}/local/include:$C_INCLUDE_PATH
  export PKG_CONFIG_PATH=${origin}/local/lib/pkgconfig:$PKG_CONFIG_PATH

  echo -e "${YELLOW}install from source${WHITE}"
  echo -e "${YELLOW}download source in ${source_path}${WHITE}"

  if [ ! -d ${source_path} ]; then
    mkdir -p ${source_path}
  fi
  if [ ! -d ${source_path} ]; then
    echo -e "${RED}${source_path} does not exist${WHITE}"
    exit 1
  fi

  # idutils
  # >= v4.5 has bugs
  install_w_config \
    -type tar \
    -cmd gid \
    -target idutils.tar.gz \
    -url https://ftp.gnu.org/gnu/idutils/idutils-4.2.tar.gz \
    -dirname idutils-4.2

  # tmux
  install_w_config \
    -type git \
    -cmd tmux \
    -url https://github.com/tmux/tmux \
    -dirname tmux \
    -newop "git checkout 2.6" \
    -newop "bash autogen.sh"

  # git
  install_w_config \
    -type git \
    -cmd git \
    -url https://github.com/git/git \
    -dirname git \
    -newop "git checkout 2.6"

  # vim
  install_w_config \
    -type git \
    -url https://github.com/vim/vim \
    -dirname vim \
    -conf --enable-terminal \
    -conf --enable-python3interp=yes

  # x264
  install_w_config \
    -type git \
    -url http://git.videolan.org/git/x264 \
    -dirname x264 \
    -newop PKG_CONFIG_PATH=${install_path}/lib/pkgconfig \
    -conf --bindir="${install_path}/bin" \
    -conf --enable-static \
    -conf --enable-shared \
    -conf --enable-pic

  # ffmpeg
  # install_w_config \
    # -type git \
    # -url \
    # -dirname ffmpeg \
    # -newop PKG_CONFIG_PATH=${install_path}/lib/pkgconfig \
    # -conf --pkg-config-flags="--static" \
    # -conf --extra-cflags="-I${install_path}/include" \
    # -conf --extra-ldflags="-L${install_path}/local/lib" \
    # -conf --extra-libs=-lpthread \
    # -conf --extra-libs=-lm \
    # -conf --bindir="${install_path}/bin" \
    # -conf --enable-gpl \
    # -conf --enable-libx264 \
    # -conf --enable-nonfree \
    # -conf --enable-avresample \
    # -conf --enable-shared \
    # -conf --enable-pic \
    # -conf --tempprefix=./temp/

elif [ ${isOSX} = 1 ]; then

  # brew
  if [ ${isOSX} = 1 ] && [ ! hash brew 2>/dev/null ]; then
    echo -e "${GREEN}Install Brew${WHITE}"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install zsh
  else
    echo -e "${RED}No Brew Install${WHITE}"
  fi
  brew install axel the_silver_searcher jq
  brew install gawk ctags cscope idutils graphviz tree tig
fi

# zsh
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
# zsh-autosuggestions
if [ ! -d "${origin}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${origin}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

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
# if [ ! -d "awesome-terminal-fonts" ]; then
  # git clone https://github.com/gabrielelana/awesome-terminal-fonts
  # cd "awesome-terminal-fonts"
  # git checkout pathcing-strategy
  # ./droid.sh
# fi

if [ ! -d "nerd-fonts" ]; then
  if [ ${isLinux} = 1 ]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git
    cd nerd-fonts
    ./install.sh
  elif [ ${isOSX} = 1 ]; then
    brew tap caskroom/fonts
    brew cask install caskroom/fonts/font-awesome-terminal-fonts
    brew cask install caskroom/fonts/font-hack-nerd-font
  fi
fi

# common apps
if [ ${isOSX} = 1 ]; then
  brew tap caskroom/cask
  brew cask install iterm2 astrill cleanmymac iina keka baidunetdisk dash foxitreader mendeley transmit

  # youcompleteme
  brew install python3 macvim
  echo "${RED}entering YouCompleteMe and run python3 install.py --clang-completer${WHITE}"
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


