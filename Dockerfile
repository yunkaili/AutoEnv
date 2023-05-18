FROM nvcr.io/nvidia/pytorch:21.10-py3
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt install -y --no-install-recommends apt-utils pkg-config build-essential locales ca-certificates
RUN apt install -y --no-install-recommends gcc python3 python3-pip python3-dev python3-setuptools
RUN apt install -y --no-install-recommends curl wget make automake cmake net-tools
RUN apt install -y --no-install-recommends libpng-dev libjpeg-dev libfreetype6-dev zlib1g-dev libevent-dev libncurses5-dev cmake-curses-gui libssl-dev
RUN apt install -y --no-install-recommends ssh axel silversearcher-ag jq gawk ctags id-utils cscope graphviz tree tig neovim tmux
RUN locale-gen en_US.UTF-8 && update-locale

# HomeBrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# Pypi
RUN pip3 install -U pip
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
WORKDIR /root

# Tmux
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf

# Oh-my-zsh & Spaceship theme
# RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_DIR_TRUNC="0"' \
    -a 'SPACESHIP_DIR_TRUNC_REPO="false"' \
    -a 'SPACESHIP_VI_MODE_SHOW="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/conda-incubator/conda-zsh-completion

# Custom Config
RUN git clone https://github.com/yunkaili/AutoEnv.git AutoEnv
RUN cp AutoEnv/.tmux.conf.local AutoEnv/.zshrc /root
RUN rm -rf AutoEnv
RUN ln -s "/root/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "/root/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
# Nvim
# RUN git clone --depth 1 https://gitlab.com/liyunkai/astronvimconfig.git /root/.config/nvim
# Fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install
# Env
RUN echo "exec zsh" >> /root/.bash_profile
CMD ["bash", "-l"]
