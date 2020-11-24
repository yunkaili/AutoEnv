FROM nvcr.io/nvidia/pytorch:20.03-py3
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse\n$(cat /etc/apt/sources.list)" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt-get install -y --no-install-recommends apt-utils pkg-config build-essential locales ca-certificates
RUN apt-get install -y --no-install-recommends gcc python3 python3-pip python3-dev python3-setuptools
RUN apt-get install -y --no-install-recommends curl wget make automake cmake net-tools
RUN apt-get install -y --no-install-recommends libpng-dev libjpeg-dev libfreetype6-dev zlib1g-dev libevent-dev libncurses5-dev cmake-curses-gui libssl-dev
RUN apt-get install -y --no-install-recommends ssh axel silversearcher-ag jq gawk ctags id-utils cscope graphviz tree tig
RUN pip3 install -U pip
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN git clone https://github.com/yunkaili/AutoEnv.git AutoEnv
RUN cp AutoEnv/.condarc AutoEnv/.tmux.conf.local AutoEnv/.zshrc /root
RUN conda env update -n base --file AutoEnv/conda.yaml
RUN rm -rf AutoEnv
WORKDIR /root
RUN conda install -c conda-forge libcurl
RUN export PATH=/opt/conda/bin/:/usr/local/cuda/bin/:/usr/local/bin:$PATH && export LD_LIBRARY_PATH=/opt/conda/lib:/usr/lib/x86_64-linux-gnu/:/usr/local/cuda/lib64/:/usr/lib:/usr/local/lib:$LD_LIBRARY_PATH
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
RUN ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
RUN locale-gen en_US.UTF-8 && update-locale
RUN git clone https://github.com/yunkaili/main .exvim
RUN echo "let g:exvim_custom_path='/root/.exvim/'" >> /root/.vimrc
RUN echo "source ~/.exvim/.vimrc" >> /root/.vimrc
WORKDIR /root/.exvim
RUN bash install.sh
RUN vim -es +PlugInstall +qall
RUN apt autoremove
