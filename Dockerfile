From nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list
#RUN export http_proxy=http://bjm7-squid4.jxq:11080
#RUN export https_proxy=http://bjm7-squid4.jxq:11080

RUN apt-get update && apt-get install -y apt-transport-https

RUN apt-get install -y --no-install-recommends \
        apt-utils \
        pkg-config \
        build-essential \
        locales \
        ca-certificates

RUN apt-get install -y --no-install-recommends \
				gcc \
				python3 \
				python3-pip \
				python3-dev \
				python3-setuptools

RUN apt-get install -y --no-install-recommends \
        zsh \
        curl \
        wget \
        make \
        automake \
        cmake

RUN apt-get install -y --no-install-recommends \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        zlib1g-dev \
        libevent-dev \
        libncurses5-dev \
        cmake-curses-gui \
        libssl-dev

RUN apt-get install -y --no-install-recommends \
        git \
        tmux \
        vim \
        htop \
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
        ffmpeg


RUN pip3 install -U pip
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install -U colorlog cython ipdb ipython numpy pillow pyyaml scikit-image scipy typing tqdm torch torchvision

WORKDIR /root
RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
CMD zsh
